//
//  shopInfo.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/26.
//

import Foundation
import MapKit


struct ShopData {
    var hit_count = Int()
    var shopNames = [String]()
    var shopCategories = [String]()
    var shopOpentimes = [String]()
    var shopMobileUrls = [String]()
    var shopLocationCoordinates = [MKPointAnnotation]()
    var shopsImages = [[String]]()
}

struct FavoriteModel {
    var didFavorite = true
    
    var favoriteButtonImage: UIImage {
        let imageName = didFavorite ? "star.fill" : "star"
        return UIImage(systemName: imageName)!
    }
    
    var favoriteButtonTintColor: UIColor {
        return didFavorite ? .nealBack : .lightGray
    }
}



