//
//  MapController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    // MARK: - Properties
    var locationManager = CLLocationManager()
    
    var shopIdArray = [String]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        self.view.backgroundColor = UIColor(red:0.7,green:0.7,blue:0.7,alpha:1.0)
        
        navigationController?.title = "Map"
//        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        
        var topPadding: CGFloat = 0
        var bottomPadding: CGFloat = 0
        var leftPadding: CGFloat = 0
        var rightPadding: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left
            rightPadding = window!.safeAreaInsets.right
        }
 
        CLLocationManager.locationServicesEnabled()
 

        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            print("DEBUG: NotDetermined..")
            locationManager.requestWhenInUseAuthorization()
            print("DEBUG: ")
        case .restricted:
            print("DEBUG: Restricted..")
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse..")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways..")
        default:
            print("DEBUG: Not allowed..")
        }
 
        locationManager.startUpdatingLocation()

        let mapView = MKMapView()
        
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let rect = CGRect(x: leftPadding,
                          y: topPadding,
                          width: screenWidth - leftPadding - rightPadding,
                          height: screenHeight - topPadding - bottomPadding )
        
        mapView.frame = rect
        mapView.delegate = self

        var region:MKCoordinateRegion = mapView.region
        region.center = mapView.userLocation.coordinate
        
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        mapView.setRegion(region,animated:true)

        self.view.addSubview(mapView)
        mapView.mapType = MKMapType.mutedStandard
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    }
    
//    func getData() {
//        var text = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=9694fae31f9af044&lat=34.67&lng=135.52&range=5&order=4"
//        //addingPercentEncodingでtext中の日本語をAlamofireに対応させる。(そのままだと怒られる)
//        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        print("DEBUG: \(url)")
//        //Requestを送る
//        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
//        //JSON解析
//        //40個値が返ってくるので、for文をすべて配列に入れる
//            print("DEBUG: \(response)")
//
//            switch response.result {
//            case .success:
//                for i in 0...5 {
//                    let json: JSON = JSON(response.data as Any)
//                    //i番目のitems中のidに含まれるvideoIdを取得
//                    guard let shopId = json["shop"][i]["id"].string else { return }
////                    guard let publishedAt = json["items"][i]["snippet"]["publishedAt"].string else { return }
////                    guard let title = json["items"][i]["snippet"]["title"].string else { return }
////                    guard let imageURLString = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string else { return }
////                    let youtubeURL = "https://www.youtube.com/watch?v=\(videoID)"
////                    guard let channelTitle = json["items"][i]["snippet"]["channelTitle"].string else { return }
////
//                    self.shopIdArray.append(shopId)
//////                    self.publishedAtArray.append(publishedAt)
////                    self.titleArray.append(title)
////                    self.imageURLArray.append(imageURLString)
////                    self.channelTitleArray.append(channelTitle)
////                    self.youtubeURLArray.append(youtubeURL)
//                    print(shopId)
//                }
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//
//        }
//    }
    
}

