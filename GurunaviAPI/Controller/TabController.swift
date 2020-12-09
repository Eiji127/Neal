//
//  TabController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit

class TabController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    // MARK: - Helpers
    
    func configureTabBar() {
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navFeed = templateNavigationController(image: .actions, rootViewController: feed)
        
        let map = MapController()
        let navMap = templateNavigationController(image: .actions, rootViewController: map)
        
        viewControllers = [navFeed, navMap]
    }

    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.tabBarItem.image = image
            nav.navigationBar.barTintColor = .white
            
            return nav
        }
}
