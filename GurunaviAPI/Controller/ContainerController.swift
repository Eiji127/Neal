//
//  ContainerController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/21.
//

import UIKit
import StoreKit

final class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(closeMenuBar))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
        
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    // MARK: - Selectors
    
    @objc func closeMenuBar() {
        isExpanded = !isExpanded
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = 0
            self.dimmingView.frame.origin.x = self.centerController.view.frame.width
        }, completion: nil)
        animateStatusBar()
    }
    
    // MARK: - Helpers
    
    private func configureHomeController() {
        let tabBarController = TabBarController()
        tabBarController.tabDelegate = self
        centerController = tabBarController
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    private func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    private func animatedPanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 120
                self.dimmingView.frame.origin.x = self.centerController.view.frame.origin.x
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
                self.dimmingView.frame.origin.x = self.centerController.view.frame.width
                
            }) { (_) in
                
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
                
            }
        }
        
        animateStatusBar()
    }
    
    private func didSelectMenuOption(menuOption: MenuOption) {
        
        switch menuOption {
        case .Info:
            let appInfoController = AppInfoController()
            let navigationController = UINavigationController(rootViewController: appInfoController)
            present(navigationController, animated: true, completion: nil)

        case .Inbox:
            let favoriteController = FavoriteShopsController(collectionViewLayout: UICollectionViewFlowLayout())
            let navigationController = UINavigationController(rootViewController: favoriteController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            
        case .Notifications:
            print("show notifications...")
            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1550909765?action=write-review")
            else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            
        case .Settings:
            let settingController = SettingController()
            let navigationController = UINavigationController(rootViewController: settingController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            
//            let settingController = SettingsController()
//            let navigationController = UINavigationController(rootViewController: settingController)
//            navigationController.modalPresentationStyle = .fullScreen
//            present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    private func checkIsExpanded(menuOption: MenuOption) {
        if !isExpanded {
            view.addSubview(dimmingView)
            dimmingView.frame = view.bounds
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatedPanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatedPanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}

extension ContainerController: TabBarDelegate {
    func configureSideMenuBar() {
        guard let menuOption = MenuOption(rawValue: 1) else {
            return
        }
        checkIsExpanded(menuOption: menuOption)
    }
}

