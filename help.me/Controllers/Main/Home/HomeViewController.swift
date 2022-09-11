//
//  HomeViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit

public final class HomeViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var profileAvatarButton: UIButton!
    @IBOutlet private weak var profileFullNameLabel: UILabel!
    @IBOutlet private weak var profileAmountLabel: UILabel!
    @IBOutlet private weak var storiesCollectionView: UICollectionView!
    @IBOutlet private weak var lastWorksTitleLabel: UILabel!
    @IBOutlet private weak var lastWorksTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var lastWorksSeeAllButton: UIButton!
    @IBOutlet private weak var lastWorksCollectionView: UICollectionView!
    @IBOutlet private weak var topWorkersCompaniesTitleLabel: UILabel!
    @IBOutlet private weak var topWorkersCompaniesTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topWrkersCompaniesSeeAllButton: UIButton!
    @IBOutlet private weak var topWorkersCompaniesCollectionView: UICollectionView!
    @IBOutlet private weak var topCategoriesTitleLabel: UILabel!
    @IBOutlet private weak var topCategoriesTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topCategoriesSeeAllButton: UIButton!
    @IBOutlet private weak var topCategoriesCollectionView: UICollectionView!
    
    // MARK: Properties
    private var stories: Stories?
    private var works: Works?
    private var users: Users?
    private var categories: Categories?
    private var selectedCategory: Category?
    private var isLoadingStories = false
    private var isLoadingWorks = false
    private var isLoadingCategories = false

    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupProfile()
        getStories()
        getWorks()
        getUsers()
        getCategories()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileAvatarButton.setCornerRadius(profileAvatarButton.frame.height / 2)
    }
    
    // MARK: Methods
    public override func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func setupView() {
        let profileStatusColor = UIColor.hex_B98538
        profileView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        profileAvatarButton.tintColor = profileStatusColor
        profileAvatarButton.setBorder(withColor: profileStatusColor, andWidth: 2)
        profileAvatarButton.imageView?.contentMode = .scaleAspectFill
        if isSmallDevice {
            lastWorksTitleLabelTopConstraint.constant = 8
            topWorkersCompaniesTitleLabelTopConstraint.constant = 8
            topCategoriesTitleLabelTopConstraint.constant = 6
        }
    }
    
    private func setupCollectionViews() {
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        storiesCollectionView.register(StoriesCollectionViewCell.cellNibName, forCellWithReuseIdentifier: StoriesCollectionViewCell.cellIdentifier)
        lastWorksCollectionView.delegate = self
        lastWorksCollectionView.dataSource = self
        lastWorksCollectionView.register(LastWorksCollectionViewCell.cellNibName, forCellWithReuseIdentifier: LastWorksCollectionViewCell.cellIdentifier)
        topWorkersCompaniesCollectionView.delegate = self
        topWorkersCompaniesCollectionView.dataSource = self
        topWorkersCompaniesCollectionView.register(TopWorkersCompaniesCollectionViewCell.cellNibName, forCellWithReuseIdentifier: TopWorkersCompaniesCollectionViewCell.cellIdentifier)
        topCategoriesCollectionView.delegate = self
        topCategoriesCollectionView.dataSource = self
        topCategoriesCollectionView.register(TopCategoriesCollectionViewCell.cellNibName, forCellWithReuseIdentifier: TopCategoriesCollectionViewCell.cellIdentifier)
    }
    
    private func setupProfile() {
        profileFullNameLabel.text = profile?.name
        profileAmountLabel.text = profile?.balance
        if let avatar = profile?.avatar {
            profileAvatarButton.setImage(avatar, for: .normal)
        } else {
            profileAvatarButton.setImage(.iconProfileDefaultAvatar, for: .normal)
            setProfileAvatar()
        }
    }
    
    // MARK: Localization
    public override func setupLocalization() {
        lastWorksTitleLabel.setLocalizedString(.home_lastWorks)
        lastWorksSeeAllButton.setLocalizedString(.home_seeAll)
        topWorkersCompaniesTitleLabel.setLocalizedString(.home_topWorkersCompanies)
        topWrkersCompaniesSeeAllButton.setLocalizedString(.home_seeAll)
        topCategoriesTitleLabel.setLocalizedString(.home_topCategories)
        topCategoriesSeeAllButton.setLocalizedString(.home_seeAll)
    }
    
    // MARK: Actions
    @IBAction private func profileAvatarButtonAction(_ sender: UIButton) {
        tabBarController?.selectTabBarItem(for: .profile)
    }
    
    @IBAction private func notificationsButtonAction(_ sender: UIButton) {
        pushToNotificationsViewController()
    }
    
    @IBAction private func searchButtonAction(_ sender: UIButton) {
        showDevelopmentAlert()
    }
    
    @IBAction private func lastWorksSeeAllButtonAction(_ sender: UIButton) {
        pushToSeeAllViewController(forMenu: .works)
    }
    
    @IBAction private func topWorkersCompaniesSeeAllButtonAction(_ sender: UIButton) {
        pushToSeeAllViewController(forMenu: .workers)
    }
    
    @IBAction private func topCategoriesSeeAllButtonAction(_ sender: UIButton) {
        pushToSeeAllViewController(forMenu: .categories)
    }
}

// MARK: Navigations
extension HomeViewController {
    private func presentStoryViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .storyViewController) as? StoryViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        if let stories = stories {
            viewController.setStories(stories)
        }
        present(viewController, animated: true)
    }
    
    private func pushToNotificationsViewController() {
        guard let viewController = viewController(from: .main, withIdentifier: .notificationsViewController) as? NotificationsViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToOfferViewController(for work: Work) {
        guard let viewController = viewController(from: .main, withIdentifier: .offerViewController) as? OfferViewController else { return }
        viewController.setSelectedWork(work)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToProfileViewController(for user: User) {
        guard let viewController = viewController(from: .main, withIdentifier: .profileViewController) as? ProfileViewController else { return }
        viewController.setSelectedUser(user)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToSeeAllViewController(forMenu type: SeeAllViewController.MenuType) {
        guard let viewController = viewController(from: .main, withIdentifier: .seeAllViewController) as? SeeAllViewController else { return }
        viewController.setMenu(type: type)
        viewController.setWorks(works)
        viewController.setUsers(users)
        viewController.setCategories(categories)
        viewController.categoryDidSelected = { [weak self] selectedCategory in
            guard let self = self else { return }
            self.categories?.data?.forEach({ category in
                    category.isSelected = category.id == selectedCategory.id
            })
            self.selectedCategory = selectedCategory
            self.topCategoriesCollectionView.reloadData()
            self.getWorks()
            self.getUsers()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Requests
extension HomeViewController {
    private func getStories(for page: Int = 1) {
        if page == 1 {
            showActivityIndicator()
        }
        isLoadingStories = true
        NetworkManager.shared.getStories(for: page) { [weak self] response in
            guard let self = self else { return }
            if self.stories != nil {
                self.stories?.updateData(with: response)
            } else {
                self.stories = response
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoadingStories = false
                self.storiesCollectionView.reloadData()
            }
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.isLoadingStories = false
            self.hideActivityIndicator()
        }
    }
    
    private func getWorks(for page: Int = 1) {
        if page == 1 {
            showActivityIndicator()
        }
        isLoadingWorks = true
        NetworkManager.shared.getWorks(with: selectedCategory?.id, page: page) { [weak self] response in
            guard let self = self else { return }
            if self.works != nil {
                self.works?.updateData(with: response)
            } else {
                self.works = response
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoadingWorks = false
                self.lastWorksCollectionView.reloadData()
            }
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.isLoadingWorks = false
            self.hideActivityIndicator()
        }
    }
    
    private func getUsers() {
        showActivityIndicator()
        NetworkManager.shared.getUsers(with: selectedCategory?.id) { [weak self] response in
            guard let self = self else { return }
            self.users = response
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.topWorkersCompaniesCollectionView.reloadData()
            }
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
    
    private func getCategories(for page: Int = 1) {
        if page == 1 {
            showActivityIndicator()
        }
        isLoadingCategories = true
        NetworkManager.shared.getCategories(for: page) { [weak self] response in
            guard let self = self else { return }
            if self.categories != nil {
                self.categories?.updateData(with: response)
                ConfigDataProvider.categories?.updateData(with: response)
            } else {
                self.categories = response
                ConfigDataProvider.categories = response
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoadingCategories = false
                self.topCategoriesCollectionView.reloadData()
            }
            self.hideActivityIndicator()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.isLoadingCategories = false
            self.hideActivityIndicator()
        }
    }
    
    private func setProfileAvatar() {
        guard let avatarName = profile?.avatarName else { return }
        NetworkManager.shared.getImage(with: avatarName) { [weak self] avatar in
            guard let self = self else { return }
            self.profileAvatarButton.setImage(avatar, for: .normal)
            ConfigDataProvider.currentProfile?.avatar = avatar
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(with: error)
            self.hideActivityIndicator()
        }
    }
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case storiesCollectionView:
                stories?.data?.enumerated().forEach({ (index, story) in
                    story.indexPath = nil
                    if index == indexPath.item {
                        story.indexPath = indexPath
                    }
                })
                presentStoryViewController()
            case lastWorksCollectionView:
                guard let selectedWork = works?.data?[indexPath.row] else { return }
                pushToOfferViewController(for: selectedWork)
            case topWorkersCompaniesCollectionView:
                guard let selectedProfile = users?.data?[indexPath.row] else { return }
                pushToProfileViewController(for: selectedProfile)
            case topCategoriesCollectionView:
                categories?.data?.forEach({ category in
                    category.isSelected = false
                })
                categories?.data?[indexPath.row].isSelected.toggle()
                topCategoriesCollectionView.reloadData()
                selectedCategory = categories?.data?[indexPath.row]
                getWorks()
                getUsers()
            default: break
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case storiesCollectionView: return stories?.data?[indexPath.row].size ?? .zero
            case lastWorksCollectionView: return works?.data?[indexPath.row].size ?? .zero
            case topWorkersCompaniesCollectionView: return users?.data?[indexPath.row].size ?? .zero
            case topCategoriesCollectionView: return categories?.data?[indexPath.row].size ?? .zero
            default: return .zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
            case storiesCollectionView:
                guard let data = stories?.data, let currentPage = stories?.currentPage, let nextPage = stories?.nextPage, let lastPage = stories?.lastPage else { return }
                if !isLoadingStories, data.count != 0, indexPath.item == data.count - 5, currentPage < lastPage {
                    getStories(for: nextPage)
                }
            case lastWorksCollectionView:
                guard let data = works?.data, let currentPage = works?.currentPage, let nextPage = works?.nextPage, let lastPage = works?.lastPage else { return }
                if !isLoadingWorks, data.count != 0, indexPath.item == data.count - 5, currentPage < lastPage {
                    getWorks(for: nextPage)
                }
            case topCategoriesCollectionView:
                guard let data = categories?.data, let currentPage = categories?.currentPage, let nextPage = categories?.nextPage, let lastPage = categories?.lastPage else { return }
                if !isLoadingCategories, data.count != 0, indexPath.item == data.count - 5, currentPage < lastPage {
                    getCategories(for: nextPage)
                }
            default: break
        }
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case storiesCollectionView: return stories?.data?.count ?? 0
            case lastWorksCollectionView: return works?.data?.count ?? 0
            case topWorkersCompaniesCollectionView: return users?.data?.count ?? 0
            case topCategoriesCollectionView: return categories?.data?.count ?? 0
            default: return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case storiesCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionViewCell.cellIdentifier, for: indexPath) as? StoriesCollectionViewCell, let story = stories?.data?[indexPath.item] else { return UICollectionViewCell() }
                cell.setData(from: story)
                return cell
            case lastWorksCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastWorksCollectionViewCell.cellIdentifier, for: indexPath) as? LastWorksCollectionViewCell, let work = works?.data?[indexPath.item] else { return UICollectionViewCell() }
                cell.setData(from: work)
                return cell
            case topWorkersCompaniesCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopWorkersCompaniesCollectionViewCell.cellIdentifier, for: indexPath) as? TopWorkersCompaniesCollectionViewCell, let user = users?.data?[indexPath.item] else { return UICollectionViewCell() }
                cell.setData(from: user)
                return cell
            case topCategoriesCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCategoriesCollectionViewCell.cellIdentifier, for: indexPath) as? TopCategoriesCollectionViewCell, let category = categories?.data?[indexPath.item] else { return UICollectionViewCell() }
                cell.setData(from: category)
                return cell
            default: return UICollectionViewCell()
        }
    }
}
