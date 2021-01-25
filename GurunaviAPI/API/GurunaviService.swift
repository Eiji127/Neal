//
//  GurunaviService.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/10.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


struct GurunaviService {
    static var shared = GurunaviService()
    
    func fetchData() {
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=15"
    }
}
