//
//  TabBarController.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit

public final class TabBarController: UITabBarController {
    
    // MARK: Properties
    static public var selectedTab = 0
    private let tabBarBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .hex_FFFFFF
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.hex_000000.withAlphaComponent(0.1).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        return view
    }()
    
    // MARK: View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarBackgroundView.frame = tabBar.frame
    }

    // MARK: Methods
    private func setupTabBar() {
        delegate = self
        if #available(iOS 15, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .hex_FFFFFF
            tabBarAppearance.shadowColor = .hex_FFFFFF
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.hex_292E39]
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.hex_6BC24D]
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.hex_292E39], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.hex_6BC24D], for: .selected)
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
        }
        addTabBarBackgroundView()
        hideTabBarBorder()
        viewControllers?[1].view.clipsToBounds = true
    }
    
    private func addTabBarBackgroundView() {
        tabBarBackgroundView.frame = tabBar.frame
        view.addSubview(tabBarBackgroundView)
        view.bringSubviewToFront(self.tabBar)
    }
    
    private func hideTabBarBorder()  {
        let tabBar = self.tabBar
        tabBar.backgroundImage = UIImage.from(color: .clear)
        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
    }
    
    public func selectTabBarItem(for type: TabBarItemType) {
        let index = type.rawValue
        TabBarController.selectedTab = index
        selectedIndex = index
    }
    
    public func setTabBarHidden(_ hidden: Bool) {
        tabBar.isHidden = hidden
        tabBarBackgroundView.isHidden = hidden
    }
}

// MARK: UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    public override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) { }
}
