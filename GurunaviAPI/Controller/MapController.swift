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
    
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private let currentLocationButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: ""), for: .normal)
        button.setDimensions(width: 60, height: 60)
        button.layer.cornerRadius = 60 / 3
        button.backgroundColor = .gray
        return button
    }()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.addSubview(map)
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
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.title = "Map"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.title = "Gurunavi API"
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate,
                                         span: MKCoordinateSpan(
                                            latitudeDelta: 0.9,
                                            longitudeDelta: 0.9
                                         )
        ),
        animated: true)
        map.addAnnotation(pin)
    }
    
    func addAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        map.addAnnotation(annotation)
    }
}

