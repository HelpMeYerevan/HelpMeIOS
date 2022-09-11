//
//  NotificationsViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/1/21.
//

import UIKit

public final class NotificationsViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var notificationsTableView: UITableView!
    @IBOutlet private weak var emptyNotificationsLabel: UILabel!
    
    // MARK: Properties
    var fakeDataSource = FakeData.chatDataSource
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
//        setupTableView()
    }
    
    // MARK: Methods
    public override func setupView() {
//        notificationsTableView.isHidden = fakeDataSource.isEmpty
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    private func setupTableView() {
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.register(ChatTableViewCell.cellNibName, forCellReuseIdentifier: ChatTableViewCell.cellIdentifier)
        notificationsTableView.contentInset.top = 16
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.notification_notifications)
        emptyNotificationsLabel.setLocalizedString(.notification_emptyNotifications)
    }
    
    // MARK: Actions
    @IBAction private func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController(from: .main, withIdentifier: .currentChatViewController) as? CurrentChatViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellIdentifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.setData(from: fakeDataSource[indexPath.row])
        return cell
    }
}
