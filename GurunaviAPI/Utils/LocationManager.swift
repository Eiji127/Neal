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
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        print("DEBUG: fired Method'getUserLocation'...")
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        print("DEBUG: Done startUpdatingLocation...")
    }
}
