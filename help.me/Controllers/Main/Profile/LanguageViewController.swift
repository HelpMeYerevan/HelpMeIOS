//
//  LanguageViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 12/3/21.
//

import UIKit

public final class LanguageViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var languageTableView: UITableView!

    // MARK: Properties
    private var languages: [Language]?
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLanguages()
    }
    
    // MARK: Methods
    public override func setupView() {
        topView.setShadow(shadowInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), cornerRadius: Constants.cornerRadius_15)
    }
    
    private func setupTableView() {
        languageTableView.delegate = self
        languageTableView.dataSource = self
        languageTableView.register(LanguageTableViewCell.cellNibName, forCellReuseIdentifier: LanguageTableViewCell.cellIdentifier)
        languageTableView.contentInset.top = 16
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        backButton.setLocalizedString(.language_languages)
    }
    
    // MARK: Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        popViewController()
    }
}

// MARK: Navigations
extension LanguageViewController {
    private func pushToTabBarViewController() {
        guard let viewController = viewController(from: .authorization, withIdentifier: .launchViewController) as? LaunchViewController else { return }
        UIApplication.sceneDelegateWindow?.rootViewController = viewController
        UIApplication.sceneDelegateWindow?.makeKeyAndVisible()
    }
}

// MARK: Requests
extension LanguageViewController {
    private func getLanguages() {
        if ConfigDataProvider.languages != nil {
            languages = ConfigDataProvider.languages
            languageTableView.reloadData()
        } else {
            showActivityIndicator()
            NetworkManager.shared.getLanguages() { [weak self] response in
                guard let self = self, let languages = response.languages else { return }
                if languages.isEmpty  {
                    self.languages = [ConfigDataProvider.currentLanguage]
                } else {
                    self.languages = languages
                    self.languages?[languages.count - 1].isLastRow = true
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.languageTableView.reloadData()
                }
                self.hideActivityIndicator()
            } failure: { [weak self] error in
                guard let self = self else { return }
                self.showAlert(with: error)
                self.hideActivityIndicator()
            }
        }
    }
}


// MARK: UITableViewDelegate
extension LanguageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedLanguage = languages?[indexPath.row] else { return }
        ConfigDataProvider.currentLanguage = selectedLanguage
        pushToTabBarViewController()
    }
}

// MARK: UITableViewDataSource
extension LanguageViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.cellIdentifier, for: indexPath) as? LanguageTableViewCell, let language = languages?[indexPath.row] else { return UITableViewCell() }
        cell.setData(from: language)
        return cell
    }
}
