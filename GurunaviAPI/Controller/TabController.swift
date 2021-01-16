//
//  TabController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit

class TabController: UITabBarController {
    
    // MARK: - Properties
    
    private let gurunaviImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Image-2")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.9
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureLogoImage()
    }
    
    // MARK: - Helpers
    
    func configureTabBar() {
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navFeed = templateNavigationController(image: .actions, rootViewController: feed)
        let map = MapController()
        let navMap = templateNavigationController(image: .actions, rootViewController: map)
        
        viewControllers = [navFeed, navMap]
    }
    
    func configureLogoImage() {
        view.addSubview(gurunaviImage)
        gurunaviImage.anchor(left: view.leftAnchor, bottom: tabBar.topAnchor, right: view.rightAnchor, height: 80)
    }

    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
}
