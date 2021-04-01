//
//  LocationManager.swift
//  GurunaviAPI
//
//  Created by 白数叡司 on 2021/01/20.
//

import UIKit
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
        getUserLocation { location in
            
            let locationLatitude = String(CLLocationDegrees(location.coordinate.latitude))
            let locationLongitude = String(CLLocationDegrees(location.coordinate.longitude))
            
            copletion(locationLatitude, locationLongitude)
        }
    }
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("未決定の場合")
        case .authorizedAlways:
            print("常に許可した場合")
        case .authorizedWhenInUse:
            print("使用中のみ許可した場合")
        case .denied:
            print("許可しない場合")
            
        case .restricted:
            print("位置情報を利用できない制限がある場合")
        @unknown default:
            fatalError("CLAuthorizationStatusの種類が増えているので、条件を見直す必要があります。")
        }
    }
}
