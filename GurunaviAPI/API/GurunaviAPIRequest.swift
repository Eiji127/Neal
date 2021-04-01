

import UIKit
import CoreLocation
import MapKit


class GurunaviAPIRequest {
    static let shared = GurunaviAPIRequest()
    
    func request(latitude: String, longitude: String, freeword: String, completion: @escaping(Result<ShopData?, APIError>) -> Void){
        
        var shopData = ShopData()
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else { return }
        
        guard let url = URL(string: "https://api.gnavi.co.jp/RestSearchAPI/v3/") else { return }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        components.queryItems = [
            URLQueryItem(name: "keyid", value: (apiKey as! String)),
            URLQueryItem(name: "hit_per_page", value: "30"),
            URLQueryItem(name: "freeword", value: freeword),
            URLQueryItem(name: "longitude", value: longitude),
            URLQueryItem(name: "latitude", value: latitude),
            URLQueryItem(name: "range", value: "3")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.unknown(error)))
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            if case 200..<300 = response.statusCode {
                do {
                    let decoder = JSONDecoder()
                    let shopInfo = try decoder.decode(ShopsInformation.self, from: data)
                    var hit_count: Int {
                        var count = Int(shopInfo.total_hit_count)
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
                    let fetchingMaxCount = 0...fetchingCount
                    for order in fetchingMaxCount {
                        shopData.shopNames.append(String(shopInfo.rest![order].name))
                        shopData.shopCategories.append(String(shopInfo.rest![order].category))
                        shopData.shopOpentimes.append(String(shopInfo.rest![order].opentime))
                        shopData.shopMobileUrls.append(String(shopInfo.rest![order].url))
                        shopData.shopsImages.append([shopInfo.rest![order].image_url.shop_image1, shopInfo.rest![order].image_url.shop_image2])
                        
                        var locationCoordinateLatitude: CLLocationDegrees {
                            guard let latitude = CLLocationDegrees(shopInfo.rest![order].latitude) else { return 0 }
                            return latitude
                        }
                        var locationCoordinateLongitude: CLLocationDegrees { guard let longitude = CLLocationDegrees(shopInfo.rest![order].longitude) else { return 0 }
                            return longitude
                        }
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(locationCoordinateLatitude,locationCoordinateLongitude)
                        annotation.title = String(shopInfo.rest![order].name)
                        shopData.shopLocationCoordinates.append(annotation)
                        
                    }
                    completion(.success(shopData))
                } catch let decodeError {
                    completion(.failure(APIError.decode(decodeError)))
                }
            } else {
                completion(.failure(APIError.server(response.statusCode)))
            }
        })
        task.resume()
    }
}

enum APIError: Error {
    case decode(Error)
    case noResponse
    case unknown(Error)
    case server(Int)
    case urlError
}

struct ShopsInformation: Codable {
    let total_hit_count: Int
    let rest: [ShopDatabase]?
}

struct ShopDatabase: Codable {
    let name: String
    let latitude: String
    let longitude: String
    let category: String
    let url: String
    let opentime: String
    let image_url: ImageUrl
}

struct ImageUrl: Codable {
    let shop_image1: String
    let shop_image2: String
}

