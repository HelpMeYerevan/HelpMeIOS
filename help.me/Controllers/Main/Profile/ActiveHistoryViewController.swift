//
//  ActiveHistoryViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/3/21.
//

import UIKit

public final class ActiveHistoryViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var activeTableView: UITableView!
    
    // MARK: Properties
    var fakeDataSource = FakeData.chatDataSource
    private var type: HistoryType = .active
    
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
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
        filterSegmentedControl.selectedSegmentIndex = type == .active ? 0 : 1
    }
    
    private func setupTableView() {
        activeTableView.delegate = self
        activeTableView.dataSource = self
        activeTableView.register(ChatTableViewCell.cellNibName, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
    }
    
    public func setType(_ type: HistoryType) {
        self.type = type
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        if type == .active {
            backButton.setLocalizedString(.activeHistory_active)
        } else {
            backButton.setLocalizedString(.activeHistory_history)
        }
        filterSegmentedControl.setLocalizedString(.activeHistory_active, index: 0)
        filterSegmentedControl.setLocalizedString(.activeHistory_history, index: 1)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: Navigations
extension ActiveHistoryViewController {
    private func pushToCurrentChatViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .currentChatViewController) as? CurrentChatViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UITableViewDelegate
extension ActiveHistoryViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        pushToCurrentChatViewController()
    }
}

// MARK: UITableViewDataSource
extension ActiveHistoryViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.setData(from: fakeDataSource[indexPath.row])
        return cell
    }
}
