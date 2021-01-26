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
    
    private var shopData = ShopData()
    
    private var longitude: String = "&longitude="
    private var latitude: String = "&latitude="
    
    private var mobileUrl: String = ""
    
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
        GurunaviService.shared.fetchData(latitude: latitude, longitude: longitude) { shopData in
            self.shopData = shopData
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.addMapPins(locations: self.shopData.locationCoordinatesArray)
            }
            
        }
    }
    
    @objc func setCenterButtonTapped() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.removeAnnotations(shopData.locationCoordinatesArray)
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
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
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
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinID) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView()
            annotationView?.annotation = annotation
            annotationView?.pinTintColor = .red
            annotationView?.animatesDrop = true
            annotationView?.canShowCallout = true
            
            self.mobileUrl = annotation.subtitle! ?? ""
            
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(moveToWebsite))
            
            annotationView?.addGestureRecognizer(gesture)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    @objc func moveToWebsite() {
        let webController = WebController()
        webController.mobileUrl = self.mobileUrl
        navigationController?.pushViewController(webController, animated: true)
    }
    
}



