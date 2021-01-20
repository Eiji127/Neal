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
    // MARK: - Lifecycle
    
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
        
        view.addSubview(map)
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
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
                                            latitudeDelta: 0.7,
                                            longitudeDelta: 0.7
                                         )
        ),
        animated: true)
        map.addAnnotation(pin)
    }
}

