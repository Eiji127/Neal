

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation
import MapKit

enum FetchingInformationError: Error {
    case fetchFailedOnMap, fetchFailedOnFeed
}

struct GurunaviService {
    static let shared = GurunaviService()
    
    var quere: String = "&freeword="
    var longitude: String = "&longitude="
    var latitude: String = "&latitude="
    var range: String = "&range=3"
    
    func fetchData(latitude: String, longitude: String, quere: String, completion: @escaping(ShopData) -> Void) {
        print("DEBUG: Fired fetching data...")
        var shopData = ShopData()
        
        var imageUrls = [String]()
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=30" + range + latitude + longitude + quere
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("DEBUG: \(type(of: url as! URLConvertible))")
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                let json: JSON = JSON(response.data as Any)
                var hit_count: Int {
                    guard var count = json["total_hit_count"].int else {
                        shopData.hit_count = 0
                        return shopData.hit_count
                    }
                    if count >= 15 {
                        count = 15
                    }
                    return count
                }
                
                shopData.hit_count = hit_count
                let fetchingCount = hit_count - 1
                if fetchingCount < 0 {
                    completion(shopData)
                    return
                }
                let fetchingDataMax = 0...fetchingCount
                
                for order in fetchingDataMax {
                    
                    guard let shopName = json["rest"][order]["name"].string else { return }
                    guard let shopCategory = json["rest"][order]["category"].string else { return }
                    guard let shopOpentime = json["rest"][order]["opentime"].string else { return }
                    guard let mobileUrl = json["rest"][order]["url"].string else { return }
                    guard let imageUrl1 = json["rest"][order]["image_url"]["shop_image1"].string else { return }
                    guard let imageUrl2 = json["rest"][order]["image_url"]["shop_image2"].string else { return }
                    
                    shopData.shopNames.append(shopName)
                    shopData.shopCategories.append(shopCategory)
                    shopData.shopOpentimes.append(shopOpentime)
                    shopData.shopMobileUrls.append(mobileUrl)
                    imageUrls.append(imageUrl1)
                    imageUrls.append(imageUrl2)
                    if imageUrl2 != "" {
                        imageUrls.append(imageUrl2)
                    }
                    shopData.shopsImages.append(imageUrls)
                    imageUrls.removeAll()
                }
            case .failure(let error):
                print("DEBUG: \(error)")
                break
            }
            completion(shopData)
        }
    }
    
    func fetchData(latitude: String, longitude: String, completion: @escaping(Result<ShopData, Error>) -> Void) {
        var shopData = ShopData()
        
        var imageUrls = [String]()
        
        var locationCoordinateLatitude: CLLocationDegrees = 0
        var locationCoordinateLongitude: CLLocationDegrees = 0
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=30" + range + latitude + longitude
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(url as! URLConvertible, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            print("DEBUG: \(response)")
            
            switch response.result {
            case .success:
                let json: JSON = JSON(response.data as Any)
                
                var hit_count: Int {
                    guard var count = json["total_hit_count"].int else {
                        shopData.hit_count = 0
                        return shopData.hit_count
                    }
                    if count >= 15 {
                        count = 15
                    }
                    return count
                }
                
                shopData.hit_count = hit_count
                let fetchingCount = hit_count - 1
                if fetchingCount < 0 {
                    completion(.success(shopData))
                    return
                }
                let fetchingDataMax = 0...fetchingCount
                
                for order in fetchingDataMax {
                    guard let shopName = json["rest"][order]["name"].string else {
                        return
                    }
                    guard let shopCategory = json["rest"][order]["category"].string else { return }
                    guard let shopOpentime = json["rest"][order]["opentime"].string else { return }
                    guard let mobileUrl = json["rest"][order]["url"].string else { return }
                    guard let imageUrl = json["rest"][order]["image_url"]["shop_image1"].string else { return }
                    guard let latitude = json["rest"][order]["latitude"].string else {
                        return
                    }
                    guard let longitude = json["rest"][order]["longitude"].string else { return }
                    
                    shopData.shopNames.append(shopName)
                    shopData.shopCategories.append(shopCategory)
                    shopData.shopOpentimes.append(shopOpentime)
                    shopData.shopMobileUrls.append(mobileUrl)
                    
                    imageUrls.append(imageUrl)
                    shopData.shopsImages.append(imageUrls)
                    imageUrls.removeAll()
                    
                    if latitude != "" {
                        locationCoordinateLatitude = CLLocationDegrees(latitude)!
                        locationCoordinateLongitude = CLLocationDegrees(longitude)!
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(locationCoordinateLatitude,locationCoordinateLongitude)
                        annotation.title = shopName
//                        annotation.subtitle = mobileUrl
                        shopData.shopLocationCoordinates.append(annotation)
                    }
                }
                completion(.success(shopData))
            case .failure(let error):
                completion(.failure(error))
                print("DEBUG: cannot fetching information: \(error)")
                break
            }
//            completion(shopData)
        }
    }
}
