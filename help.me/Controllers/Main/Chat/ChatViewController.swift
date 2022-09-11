//
//  ChatViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/24/21.
//

import UIKit

public final class ChatViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var chatTableView: UITableView!
    
    // MARK: Properties
    var fakeDataSource = FakeData.chatDataSource
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBarHidden(false)
    }
    
    // MARK: Methods
    public override func setupView() {
        chatTableView.isHidden = fakeDataSource.isEmpty
    }
    
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(ChatTableViewCell.cellNibName, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
        chatTableView.contentInset.top = 16
    }
    
    // MARK: Navigations
    private func pushToCurrentChatViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .currentChatViewController) as? CurrentChatViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToCurrentChatViewController()
    }
}

// MARK: UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.setData(from: fakeDataSource[indexPath.row])
        return cell
    }
}
