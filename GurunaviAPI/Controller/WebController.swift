//
//  WebController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/25.
//

import UIKit
import WebKit


class WebController: UIViewController {
    
    var mobileUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureNavigationBarRightButton()
        
        self.overrideUserInterfaceStyle = .light
    }
    
    func configureWebView() {
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let myURL = URL(string: mobileUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
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
    
    @objc func shareImageTapped() {
        let shareUrl = mobileUrl
        let shareItems = [shareUrl]
        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}
