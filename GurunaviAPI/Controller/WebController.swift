//
//  WebController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/25.
//

import UIKit
import WebKit


final class WebController: UIViewController {
    
    // MARK: - Properties
    
    var mobileUrl: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureNavigationBarRightButton()
        
        self.overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemRed
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Selectors
    
    @objc func shareImageTapped() {
        let shareUrl = mobileUrl
        let shareItems = [shareUrl]
        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureWebView() {
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let myURL = URL(string: mobileUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.backgroundColor = .nealBack
        self.view.addSubview(webView)
    }
    
    func configureNavigationBarRightButton() {
        
        let shareButton = UIImageView()
        shareButton.image = UIImage(systemName: "square.and.arrow.up")
        shareButton.tintColor = .white
        shareButton.setDimensions(width: 27, height: 27)
        shareButton.layer.masksToBounds = true
        shareButton.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(shareImageTapped))
        shareButton.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
}
