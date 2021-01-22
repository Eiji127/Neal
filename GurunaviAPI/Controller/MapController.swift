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
        
        let region = MKCoordinateRegion(center: mapView.centerCoordinate,
                                        span: MKCoordinateSpan(
                                           latitudeDelta: 0.005,
                                           longitudeDelta: 0.005
                                        )
        )
        mapView.setRegion(region,animated:true)
        
        navigationController?.title = "Map"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "Gurunavi API"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(mapView)
//        fetchCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
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
    }
}

