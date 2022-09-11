//
//  TabBar.swift
//  help.me
//
//  Created by Karen Galoyan on 11/13/21.
//

import UIKit

public final class TabBar: UITabBar {
    
    // MARK: View Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        customizeTabBar()
        
    }
    
    // MARK: Methods
    private func customizeTabBar() {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabBarStyle(self)
    }
    
    private func tabBarStyle(_ tabBar: UITabBar) {
        if let items = tabBar.items {
            for item in items {
                switch item.tag {
                    case 0:
                        item.title?.setLocalizedString(.tabBar_Home)
                        item.image = UIImage.iconHome?.withRenderingMode(.alwaysOriginal)
                        item.selectedImage = UIImage.iconHomeSelected?.withRenderingMode(.alwaysOriginal)
                    case 1:
                        item.title?.setLocalizedString(.tabBar_Map)
                        item.image = UIImage.iconMap?.withRenderingMode(.alwaysOriginal)
                        item.selectedImage = UIImage.iconMapSelected?.withRenderingMode(.alwaysOriginal)
                    case 2:
                        item.title?.setLocalizedString(.tabBar_Scan)
                        item.image = UIImage.iconScan?.withRenderingMode(.alwaysOriginal)
                        item.selectedImage = UIImage.iconScanSelected?.withRenderingMode(.alwaysOriginal)
                    case 3:
                        item.title?.setLocalizedString(.tabBar_Chat)
                        item.image = UIImage.iconChat?.withRenderingMode(.alwaysOriginal)
                        item.selectedImage = UIImage.iconChatSelected?.withRenderingMode(.alwaysOriginal)
                    case 4:
                        item.title?.setLocalizedString(.tabBar_Profile)
                        item.image = UIImage.iconProfile?.withRenderingMode(.alwaysOriginal)
                        item.selectedImage = UIImage.iconProfileSelected?.withRenderingMode(.alwaysOriginal)
                    default: break
                }
            }
        }
    }
}
