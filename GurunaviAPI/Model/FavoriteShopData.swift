//
//  FavoriteShopData.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/02/23.
//

import RealmSwift

class FavoriteShopData: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var opentime: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var mobileUrl: String = ""
}
