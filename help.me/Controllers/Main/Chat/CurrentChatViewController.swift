//
//  CurrentChatViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/1/21.
//

import UIKit

public final class CurrentChatViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var currentChatTableView: UITableView!
    @IBOutlet private weak var messageInputView: UIView!
    @IBOutlet private weak var messageInputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageInputViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var messageInputTextView: UITextView!
    
    // MARK: Properties
    var fakeDataSource = FakeData.chatDataSource
    private var messageInputTextViewExtraLinesCount: CGFloat = 0
    private var defaultInputTextViewHeight: CGFloat = 56
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
//        setupTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBarHidden(true)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        messageInputView.setShadow(cornerRadius: defaultInputTextViewHeight / 2)
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        messageInputView.setShadow(cornerRadius: messageInputView.frame.height / 2)
    }
    
    public func setupTextView() {
        messageInputTextView.textContainerInset = .zero
        messageInputTextView.contentInset = .zero
        messageInputTextView.isScrollEnabled = false
        messageInputTextView.delegate = self
    }
    
    private func setupTableView() {
        currentChatTableView.delegate = self
        currentChatTableView.dataSource = self
        currentChatTableView.register(ChatTableViewCell.cellNibName, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
        currentChatTableView.contentInset.top = 16
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: UITableViewDelegate
extension CurrentChatViewController: UITableViewDelegate { }

// MARK: UITableViewDataSource
extension CurrentChatViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.setData(from: fakeDataSource[indexPath.row])
        return cell
    }
}

// MARK: KeyboardEventsDelegate
extension CurrentChatViewController {
    public override func keyboardDidChangeFrame(willShow: Bool, keyboardHeight: CGFloat, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration) {
            self.messageInputViewBottomConstraint.constant = willShow ? keyboardHeight : 13
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: UITextViewDelegate
extension CurrentChatViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            messageInputTextViewExtraLinesCount += 1
            if messageInputTextViewExtraLinesCount < 3 {
                messageInputViewHeightConstraint.constant = defaultInputTextViewHeight + messageInputTextViewExtraLinesCount * 16
                messageInputTextView.isScrollEnabled = true
            }
        } else if text.isEmpty && textView.text.last == "\n" && messageInputTextViewExtraLinesCount >= 0 {
            messageInputTextViewExtraLinesCount -= 1
            if messageInputTextViewExtraLinesCount < 3 {
                messageInputViewHeightConstraint.constant = defaultInputTextViewHeight + messageInputTextViewExtraLinesCount * 16
            }
            if messageInputTextViewExtraLinesCount == 1 {
                messageInputTextView.isScrollEnabled = false
            }
        }
        return true
    }
}

