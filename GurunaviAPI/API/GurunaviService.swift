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
    
    private let apiKey = APIKeyManager().getValue(key: "apiKey") as? String 
    
    func fetchData(completion: @escaping([ShopInfo]) -> Void) {
        
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&name="
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            var nameArray = [String]()
            var categoryArray = [String]()
            var opentimeArray = [String]()
            var mobileUrlArray = [String]()
            
            
            let fetchingDataMax = 5
            
            switch response.result {
            case .success:
                for order in 0...fetchingDataMax {
                    let json: JSON = JSON(response.data as Any)
                    
                    guard let shopName = json["rest"][order]["name"].string else { return }
                    guard let shopCategory = json["rest"][order]["category"].string else { return }
                    guard let shopOpentime = json["rest"][order]["opentime"].string else { return }
                    guard let mobileUrl = json["rest"][order]["url_mobile"].string else { return }
                    nameArray.append(shopName)
                    categoryArray.append(shopCategory)
                    opentimeArray.append(shopOpentime)
                    mobileUrlArray.append(mobileUrl)
                }
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
}
