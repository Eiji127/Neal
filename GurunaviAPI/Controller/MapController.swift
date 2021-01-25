//
//  MapController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//
import UIKit
import SwiftyJSON
import Alamofire
import MapKit
import CoreLocation


class MapController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.userTrackingMode = .followWithHeading
        return map
    }()
    
    var locationCoordinatesArray = [MKPointAnnotation]()
    
    var nameArray = [String]()
    var mobileUrlArray = [String]()
    
    var longitude: String = "&longitude="
    var latitude: String = "&latitude="
    var range: String = "&range=3"
    
    var mobileUrl: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                        span: MKCoordinateSpan(
                                           latitudeDelta: 0.005,
                                           longitudeDelta: 0.005
                                        )
        )
        mapView.setRegion(region, animated:true)
        
        LocationManager.shared.getUserLocation()
        
        configureNavigationBar()
        configureNavigationBarRightButton()
        
        self.overrideUserInterfaceStyle = .light
        
        mapView.delegate = self
        
        configurePinOnMap()

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    // MARK: - API
    
    func fetchData() {
        
        var locationCoordinateLatitude: CLLocationDegrees = 0
        var locationCoordinateLongitude: CLLocationDegrees = 0
        var imageUrlArray = [String]()
        
        guard let apiKey = APIKeyManager().getValue(key: "apiKey") else {
            return
        }
        var text = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apiKey)&hit_per_page=30" + range + latitude + longitude
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //        let params:Parameters = [
        //            "keyid":apiKey,
        //            "format":"json",
        //            "freeword":freeword,
        //            "latitude":latitude,
        //            "longitude":longitude,
        //            "range":range,
        //            "hit_per_page":10
        //        ]
        
        print("DEBUG: Into method fetching data..")
        
        AF.request(url as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            let fetchingDataMax = 0...14
            
            print("DEBUG: requesting .GET...")
            
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
                    guard let latitude = json["rest"][order]["latitude"].string else { return
                    }
                    guard let longitude = json["rest"][order]["longitude"].string else { return }
   
                    if latitude != "" {
                        locationCoordinateLatitude = CLLocationDegrees(latitude)!
                        locationCoordinateLongitude = CLLocationDegrees(longitude)!
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(locationCoordinateLatitude,locationCoordinateLongitude)
                        annotation.title = shopName
                        annotation.subtitle = mobileUrl
                        self.locationCoordinatesArray.append(annotation)
                    }
                }
            case .failure(let error):
                print(error)
                break
            }
            print("DEBUG: \(self.nameArray)")
            
        }
    }
    
    // MARK: - Helpers
    
    func configureNavigationBar() {
        navigationController?.title = "Map"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "近辺のお店"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
    }
    
    func configureNavigationBarRightButton() {
        let setCenterButton = UIImageView()
        setCenterButton.image = UIImage(systemName: "location")
        setCenterButton.tintColor = .white
        setCenterButton.setDimensions(width: 27, height: 27)
        setCenterButton.layer.masksToBounds = true
        setCenterButton.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setCenterButtonTapped))
        setCenterButton.addGestureRecognizer(tap)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: setCenterButton)
    }
    
    func configurePinOnMap() {
        self.longitude = "&longitude="
        self.latitude = "&latitude="
        
        fetchUserLocation { latitude, longitude in
            
            self.latitude += latitude
            self.longitude += longitude
            
            self.fetchData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.addMapPins(locations: self.locationCoordinatesArray)
            }
            
        }
    }
    
    @objc func setCenterButtonTapped() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.removeAnnotations(locationCoordinatesArray)
        configurePinOnMap()
    }
    
    func fetchUserLocation(copletion: @escaping (_ latitude: String, _ longitude: String) -> Void) {
        LocationManager.shared.getUserLocation { location in
            
            let locationLatitude = String(CLLocationDegrees(location.coordinate.latitude))
            let locationLongitude = String(CLLocationDegrees(location.coordinate.longitude))
            
            copletion(locationLatitude, locationLongitude)
            
        }
    }
    
    func fetchUserLocation() {
        print("DEBUG: Moved into fetchCurrentLocation Method...")
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                print("DEBUG: getUserLocation is Fired..")
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
    }
    
    func addMapPins(locations: [MKPointAnnotation]) {
        mapView.setRegion(MKCoordinateRegion(
            center: mapView.userLocation.coordinate, span: MKCoordinateSpan(
                latitudeDelta: 0.005,
                longitudeDelta: 0.005
                                         )
        ),
        animated: true)
        mapView.addAnnotations(locations)
    }
    
    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        print(pin.coordinate)
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.005,
                                            longitudeDelta: 0.005
                                         )
        ),
        animated: true)
        mapView.addAnnotation(pin)
    }
    
    func addShopAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        print("DEBUG: Fired addShopAnnotation...")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.005,
                                            longitudeDelta: 0.005
                                         )
        ),
        animated: true)
        mapView.delegate = self
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func setCenterUserLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinID = "PIN"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? PinAnnotationView
        if annotationView == nil {
            annotationView = PinAnnotationView()
            annotationView?.annotation = annotation
            annotationView?.pinTintColor = .red
            annotationView?.animatesDrop = true
            annotationView?.canShowCallout = true
            
            self.mobileUrl = annotation.subtitle! ?? ""
            
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(moveToWebsite))
            
            annotationView?.addGestureRecognizer(gesture)
            print("DEBUG: Fired mapViewDelegate...")
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @objc func moveToWebsite() {
        print("DEBUG: Tapped annotationView...")
        let webController = WebController()
        webController.mobileUrl = self.mobileUrl
        navigationController?.pushViewController(webController, animated: true)
    }
    
}



