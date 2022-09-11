//
//  SeeAllViewController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/14/21.
//

import UIKit

public final class SeeAllViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet private var menuViewButtonsCollection: [UIButton]!
    @IBOutlet private var menuViewButtonSelectedViewsCollection: [UIView]!
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var filtersSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    private var selectedMenuType: MenuType = .works
    private var works: Works?
    private var users: Users?
    private var categories: Categories?
    public var categoryDidSelected: ((Category) -> Void)?
    
    // MARK: Enum
    public enum MenuType: Int {
        case works, workers, categories
    }
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        menuViewButtonSelectedViewsCollection.forEach { view in
            view.roundCorners(topLeft: 3, topRight: 3, bottomLeft: 0, bottomRight: 0)
        }
    }
    
    // MARK: Methods
    public override func setupView() {
        menuView.setShadow(shadowInsets: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        setMenu(for: selectedMenuType.rawValue)
        let font = UIFont.robotoMediumFont(ofSize: 12)
        filtersSegmentedControl.setTitleTextAttributes([.font: font], for: .normal)
        filtersSegmentedControl.setTitleTextAttributes([.font: font], for: .selected)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorksTableViewCell.cellNibName, forCellReuseIdentifier: WorksTableViewCell.cellIdentifier)
        tableView.register(WorkersTableViewCell.cellNibName, forCellReuseIdentifier: WorkersTableViewCell.cellIdentifier)
        tableView.register(CategoriesTableViewCell.cellNibName, forCellReuseIdentifier: CategoriesTableViewCell.cellIdentifier)
    }
    
    private func setMenu(for index: Int) {
        menuViewButtonsCollection.forEach { button in
            button.alpha = index == button.tag ? 1 : 0.5
            switch button.tag {
                case 0: button.setLocalizedString(.seeAll_works)
                case 1: button.setLocalizedString(.seeAll_workers)
                case 2: button.setLocalizedString(.seeAll_categories)
                default: break
            }
            menuViewButtonSelectedViewsCollection[button.tag].isHidden = index != button.tag
        }
        setFilters(for: index)
        selectedMenuType = MenuType(rawValue: index) ?? .works
        tableView.reloadData()
    }
    
    private func setFilters(for index: Int) {
        filtersSegmentedControl.removeAllSegments()
        switch index {
            case 0:
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_last.text, at: 0, animated: false)
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_oldest.text, at: 1, animated: false)
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_nearByMe.text, at: 2, animated: false)
            case 1:
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_individual.text, at: 0, animated: false)
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_company.text, at: 1, animated: false)
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_verified.text, at: 2, animated: false)
            case 2:
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_new.text, at: 0, animated: false)
                filtersSegmentedControl.insertSegment(withTitle: Localization.seeAll_top.text, at: 1, animated: false)
            default: break
        }
        filtersSegmentedControl.selectedSegmentIndex = 0
    }
    
    public func setMenu(type: MenuType) {
        selectedMenuType = type
    }
    
    public func setWorks(_ works: Works?) {
        self.works = works
    }
    
    public func setUsers(_ users: Users?) {
        self.users = users
    }
    
    public func setCategories(_ categories: Categories?) {
        self.categories = categories
    }
    
    // MARK: Actions
    @IBAction private func menuViewButtonsAction(_ sender: UIButton) {
        setMenu(for: sender.tag)
    }
}

// MARK: Navigations
extension SeeAllViewController {
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
}

// MARK: UITableViewDelegate
extension SeeAllViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedMenuType {
            case .works:
                guard let selectedWork = works?.data?[indexPath.row] else { return }
                pushToOfferViewController(for: selectedWork)
            case .workers:
                guard let selectedProfile = users?.data?[indexPath.row] else { return }
                pushToProfileViewController(for: selectedProfile)
            case .categories: break
        }
    }
}

// MARK: UITableViewDataSource
extension SeeAllViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedMenuType {
            case .works: return works?.data?.count ?? 0
            case .workers: return users?.data?.count ?? 0
            case .categories: return categories?.data?.count ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedMenuType {
            case .works:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WorksTableViewCell.cellIdentifier, for: indexPath) as? WorksTableViewCell, let work = works?.data?[indexPath.row] else { return UITableViewCell() }
                cell.setData(from: work)
                return cell
            case .workers:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkersTableViewCell.cellIdentifier, for: indexPath) as? WorkersTableViewCell, let user = users?.data?[indexPath.row] else { return UITableViewCell() }
                cell.setData(from: user)
                return cell
            case .categories:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTableViewCell.cellIdentifier, for: indexPath) as? CategoriesTableViewCell, let category = categories?.data?[indexPath.row] else { return UITableViewCell() }
                cell.setData(from: category)
                cell.selectButtonDidTapped = { [weak self] in
                    guard let self = self else { return }
                    self.categories?.data?.forEach({ category in
                        category.isSelected = false
                    })
                    self.categories?.data?[indexPath.row].isSelected.toggle()
                    self.tableView.reloadData()
                    self.categoryDidSelected?(category)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.popViewController()
                    }
                }
                return cell
        }
    }
}
