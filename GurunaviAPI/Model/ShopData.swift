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
    var nameArray = [String]()
    var categoryArray = [String]()
    var opentimeArray = [String]()
    var mobileUrlArray = [String]()
    var locationCoordinatesArray = [MKPointAnnotation]()
    var shopsImageArray = [[String]]()
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



