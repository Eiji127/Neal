//
//  AppInfoController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/22.
//

import UIKit
import WebKit

class AppInfoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        print(version)
        self.overrideUserInterfaceStyle = .light
    }
    
    func configureWebView() {
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let myURL = URL(string: "https://github.com/Eiji127")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        self.view.addSubview(webView)
    }
}
