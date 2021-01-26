//
//  LocationManager.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/01/20.
//

import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private var manager: CLLocationManager = {
     var locationManager = CLLocationManager()
     locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
     locationManager.distanceFilter = 5
     return locationManager
    }()
    
    var completion: ((CLLocation) -> Void)?
    
    public func fetchUserLocation(copletion: @escaping (_ latitude: String, _ longitude: String) -> Void) {
        LocationManager.shared.getUserLocation { location in
            
            let locationLatitude = String(CLLocationDegrees(location.coordinate.latitude))
            let locationLongitude = String(CLLocationDegrees(location.coordinate.longitude))
            
            copletion(locationLatitude, locationLongitude)
            
        }
    }
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        print("DEBUG: fired Method'getUserLocation'...")
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        print("DEBUG: Done startUpdatingLocation...")
    }
    
    public func getUserLocation() {
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}
