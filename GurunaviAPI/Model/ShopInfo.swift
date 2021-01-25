//
//  shopInfo.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/26.
//

import Foundation

struct ShopInfo {
    let shopName: String
    
    init(json: [String: Any]) {
        shopName = json["name"] as? String ?? ""
    }
    
    init(){
        shopName = ""
    }
}
