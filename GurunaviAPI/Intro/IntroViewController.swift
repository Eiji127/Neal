//
//  IntroViewController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/01/24.
//

import UIKit
import Lottie

class IntroViewController: UIViewController {
    // MARK: - Properties
    
    private let introScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let introAnimationView: AnimationView = {
        let animationView = AnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    
    private let onBoardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textAlignment = .center
        return label
    }()
    
    private var onboardArary = ["hello", "foodchoice", "map", "reservation", "travelers"]
    
    private var onboardStringArray = ["Welcome!!", "このアプリは近くの飲食店を探してくれたり...", "場所を教えてくれたり...", "予約もしてくれます！", "さぁ！出かけよう！！"]
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let pageCount = 4
        
        for page in 0..<pageCount {
            let animation = Animation.named(onboardArary[page])
            
            introScrollView.addSubview(introAnimationView)
            introAnimationView.frame = CGRect(x: CGFloat(page) * view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            introAnimationView.animation = animation
            introAnimationView.play()
            
            introScrollView.addSubview(onBoardLabel)
            onBoardLabel.frame = CGRect(x: CGFloat(page) * view.frame.size.width, y: view.frame.size.height / 3, width: introScrollView.frame.size.width, height: introScrollView.frame.size.height)
            onBoardLabel.text = onboardStringArray[page]
        }
    }
}

extension IntroViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
