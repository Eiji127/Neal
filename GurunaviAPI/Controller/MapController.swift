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
        return map
    }()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "Map"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "Gurunavi API"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(mapView)
        fetchCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    
    func fetchCurrentLocation() {
        print("DEBUG: Moved into fetchCurrentLocation Method...")
        LocationManager.shared.getUserLocation { [weak self] location in
            print("DEBUG: Moved into LM Closure...")
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
        mapView.addAnnotation(annotation)
    }
}

extension MapController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            let status = manager.authorizationStatus
            
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                manager.startUpdatingLocation()
                
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                
            case .denied:
                break
                
            case .restricted:
                break
                
            default:
                break
            }
        }
    }
}

