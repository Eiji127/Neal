

import UIKit
import SwiftyJSON
import Alamofire

struct GurunaviService {
    static let shared = GurunaviService()
    
    var freeword: String = "&freeword="
    var longitude: String = "&longitude="
    var latitude: String = "&latitude="
    var range: String = "&range=3"
    
    func fetchData(latitude: String, longitude: String, freeword: String, completion: @escaping(ShopData) -> Void) {
        var shopData = ShopData()
        
        var imageUrlArray = [String]()
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=30" + range + latitude + longitude + freeword
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("DEBUG: \(latitude)")
        print("DEBUG: \(longitude)")
        print("DEBUG: \(freeword)")
        
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            let fetchingDataMax = 0...14
            
            switch response.result {
            case .success:
                for order in fetchingDataMax {
                    
                    let json: JSON = JSON(response.data as Any)
                    
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
                print(error)
                break
            }
            completion(shopData)
            print("\(shopData.nameArray)")
        }
    }
}
