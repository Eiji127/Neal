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
        imageView.image = UIImage(named: "Image-3")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.9
        return imageView
    }()
    
    private let currentLocationButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.addTarget(self, action: #selector(fetchCurrentLocation), for: .touchUpInside)
        button.setDimensions(width: 50, height: 50)
        button.layer.cornerRadius = 50 / 3
        button.backgroundColor = .white
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureLogoImage()
        
        view.addSubview(currentLocationButton)
        currentLocationButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 130, paddingRight: 25)
    }
    
    // MARK: - Helpers
    
    func configureTabBar() {
        
        UITabBar.appearance().barTintColor = .red
        UITabBar.appearance().alpha = 0.9
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
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
    
    @objc func fetchCurrentLocation() {
        print("DEBUG: fetch your location...")
    }
}

extension TabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        self.currentLocationButton.isHidden = index == 0 ? true : false
    }
}
