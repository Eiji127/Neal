

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation
import MapKit

struct GurunaviService {
    static let shared = GurunaviService()
    
    var freeword: String = "&freeword="
    var longitude: String = "&longitude="
    var latitude: String = "&latitude="
    var range: String = "&range=3"
    
    func fetchData(latitude: String, longitude: String, freeword: String, completion: @escaping(ShopData) -> Void) {
        print("DEBUG: Fired fetching data...")
        var shopData = ShopData()
        
        var imageUrlArray = [String]()
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=30" + range + latitude + longitude + freeword
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            print("DEBUG: \(response)")
            
            switch response.result {
            case .success:
                print("DEBUG: into .success...")
                let json: JSON = JSON(response.data as Any)
                guard var hit_count = json["total_hit_count"].int else {
                    shopData.hit_count = 0
                    completion(shopData)
                    return
                }
                if hit_count >= 15 {
                    hit_count = 15
                }
                shopData.hit_count = hit_count
                let fetchingCount = hit_count - 1
                print("DEBUG: \(hit_count)")
                
                let fetchingDataMax = 0...fetchingCount
                
                for order in fetchingDataMax {
                    
                    guard let shopName = json["rest"][order]["name"].string else { return }
                    guard let shopCategory = json["rest"][order]["category"].string else { return }
                    guard let shopOpentime = json["rest"][order]["opentime"].string else { return }
                    guard let mobileUrl = json["rest"][order]["url"].string else { return }
                    guard let imageUrl1 = json["rest"][order]["image_url"]["shop_image1"].string else { return }
                    guard let imageUrl2 = json["rest"][order]["image_url"]["shop_image2"].string else { return }
                    
                    shopData.nameArray.append(shopName)
                    shopData.categoryArray.append(shopCategory)
                    shopData.opentimeArray.append(shopOpentime)
                    shopData.mobileUrlArray.append(mobileUrl)
                    imageUrlArray.append(imageUrl1)
                    imageUrlArray.append(imageUrl2)
                    if imageUrl2 != "" {
                        imageUrlArray.append(imageUrl2)
                    }
                    shopData.shopsImageArray.append(imageUrlArray)
                    imageUrlArray.removeAll()
                }
            case .failure(let error):
                print("DEBUG: \(error)")
                break
            }
            completion(shopData)
        }
    }
    
    func fetchData(latitude: String, longitude: String, completion: @escaping(ShopData) -> Void) {
        var shopData = ShopData()
        
        var locationCoordinateLatitude: CLLocationDegrees = 0
        var locationCoordinateLongitude: CLLocationDegrees = 0
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=30" + range + latitude + longitude
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            let json: JSON = JSON(response.data as Any)
            guard var hit_count = json["total_hit_count"].int else {
                shopData.hit_count = 0
                completion(shopData)
                return
            }
            if hit_count >= 15 {
                hit_count = 15
            }
            shopData.hit_count = hit_count
            let fetchingCount = hit_count - 1
            
            let fetchingDataMax = 0...fetchingCount

            switch response.result {
            case .success:
                for order in fetchingDataMax {
                    guard let shopName = json["rest"][order]["name"].string else {
                        return
                    }
                    guard let mobileUrl = json["rest"][order]["url"].string else {
                        return
                    }
                    guard let latitude = json["rest"][order]["latitude"].string else {
                        return
                    }
                    guard let longitude = json["rest"][order]["longitude"].string else { return }
                    
                    shopData.nameArray.append(shopName)
                    shopData.mobileUrlArray.append(mobileUrl)
                    
                    if latitude != "" {
                        locationCoordinateLatitude = CLLocationDegrees(latitude)!
                        locationCoordinateLongitude = CLLocationDegrees(longitude)!
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(locationCoordinateLatitude,locationCoordinateLongitude)
                        annotation.title = shopName
//                        annotation.subtitle = mobileUrl
                        shopData.locationCoordinatesArray.append(annotation)
                    }
                }
            case .failure(let error):
                print(error)
                break
            }
            completion(shopData)
        }
    }
}
