//
//  WebController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/25.
//

import UIKit
import WebKit

class WebController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        let myURL = URL(string:"https://google.com") 
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        self.view.addSubview(webView)
    }
}
