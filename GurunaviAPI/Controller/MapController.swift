//
//  MapController.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2020/12/07.
//
import UIKit
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
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
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
        
        navigationController?.title = "Map"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "Gurunavi API"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
        
        configureNavigationBarRightButton()
        
//        fetchCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
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
    
    @objc func setCenterButtonTapped() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func fetchCurrentLocation() {
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
    
    func addAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.005,
                                            longitudeDelta: 0.005
                                         )
        ),
        animated: true)
        mapView.addAnnotation(annotation)
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func setCenterUserLocation() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
}

