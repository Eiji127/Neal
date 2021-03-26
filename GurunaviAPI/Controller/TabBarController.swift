//
//  TabBarController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit


protocol TabBarDelegate: class {
    func configureSideMenuBar()
}

protocol TabBarDelegateForFeedController {
    func moveTopView()
}


class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let gurunaviImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image-3")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.9
        return imageView
    }()
    
    var tabDelegate: TabBarDelegate?

    var tabDelegateForFeed: TabBarDelegateForFeedController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
//        configureLogoImage()
    }
    
    // MARK: - Helpers
    
    func configureTabBar() {
        
        UITabBar.appearance().barTintColor = .red
        UITabBar.appearance().alpha = 0.9
        UITabBar.appearance().tintColor = .white
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feed.homeDelegate = self
        
        let navFeed = templateNavigationController(image: UIImage(systemName: "house.fill")!, rootViewController: feed)
        
        let map = MapController()
        let navMap = templateNavigationController(image: UIImage(systemName: "mappin.and.ellipse")!, rootViewController: map)
        
        viewControllers = [navFeed, navMap]
    }
    
    func configureLogoImage() {
        view.addSubview(gurunaviImage)
        gurunaviImage.anchor(bottom: tabBar.topAnchor, right: view.rightAnchor)
    }

    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
    
}

// MARK: - UITabBarDelegate

extension TabBarController {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let tabBarIndex = selectedIndex
        
        if tabBarIndex == 0 {
            print("DEBUG: tabBarIndex is 0...")
            tabDelegateForFeed?.moveTopView()
        }
        
    }
    
}

// MARK: - HomeControllerDelegate

extension TabBarController: HomeControllerDelegate {
    
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        
        tabDelegate?.configureSideMenuBar()
        
    }
    
}

