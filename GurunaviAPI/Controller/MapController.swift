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

//        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.title = "Map"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "Gurunavi API"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
        
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
}

