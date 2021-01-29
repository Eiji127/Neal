//
//  SplashViewController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/01/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chooseShouldLaunchViewController()
    }
    
    fileprivate func chooseShouldLaunchViewController() {
        if UserDefaults.standard.bool(forKey: "tutorialShown") == false {
            launchTutorial()
        } else {
            launchHome()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func launchTutorial(){
        UserDefaults.standard.set(true, forKey: "tutorialShown")

        self.navigationController?.pushViewController(IntroViewController(), animated: true)
     }
    func launchHome(){
        self.navigationController?.pushViewController(IntroViewController(), animated: true)
     }
}
