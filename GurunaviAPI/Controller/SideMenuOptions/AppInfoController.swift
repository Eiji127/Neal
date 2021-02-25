//
//  AppInfoController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/22.
//

import UIKit
import WebKit

class AppInfoController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        view.backgroundColor = .nealBack
        self.overrideUserInterfaceStyle = .light
        
        navigationController?.navigationBar.barTintColor = .nealBack
//        navigationController?.navigationBar.titleTextAttributes = [
//            .foregroundColor: UIColor.systemRed
//        ]
//        navigationItem.title = "nealについて"
        navigationController?.navigationBar.tintColor = .systemRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(dismissController))
        
//        configureScrollView()
        
    }
    
    // MARK: - Handlers
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
//    func configureScrollView() {
//
//        let screenWidth = Int( UIScreen.main.bounds.size.width)
//        let screenHeight = Int(UIScreen.main.bounds.size.height * 3)
//
//        let scrollView = UIScrollView()
//        scrollView.frame = self.view.frame
//        scrollView.contentSize = CGSize(width:screenWidth, height:screenHeight)
//
//        let contentView = configureTopView()
//        scrollView.addSubview(contentView)
//
//
//        self.view.addSubview(scrollView)
//
//    }
    
//    func configureTopView() -> UIView {
//
//        let containerView = UIView()
//
//        let nealView = UIView()
//        nealView.backgroundColor = .red
//        nealView.alpha = 0.8
//
////        nealView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleToFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        imageView.setDimensions(width: 150, height: 50)
////        imageView.backgroundColor = .black
//        imageView.image = UIImage(named: "nealIcon")
//
//        nealView.addSubview(imageView)
//        imageView.centerY(inView: nealView)
//        imageView.centerX(inView: nealView)
//
//        containerView.addSubview(nealView)
//        nealView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
//
//        return containerView
//    }
    
    
    func configureWebView() {
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let myURL = URL(string: "https://qiita.com/Cychow/private/7d5812a70092ea3faa53")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        self.view.addSubview(webView)
    }
}
