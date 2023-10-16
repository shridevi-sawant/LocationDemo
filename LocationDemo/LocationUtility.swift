//
//  LocationUtility.swift
//  LocationDemo
//
//  Created by Shridevi Sawant on 13/10/23.
//

import Foundation
import CoreLocation

class LocationUtility: NSObject {
    
    let locManager = CLLocationManager()
    var isAuthorized = false
    var currentLocation: CLLocation?
    
    override init() {
        print("init of Location Utility")
        super.init()
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locManager.distanceFilter = 10 // meters
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
    }
    
    func startTracking() {
        print("Tracking started")
        locManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locManager.stopUpdatingLocation()
        print("Tracking stopped")
    }
    
    func getAddress(callback: @escaping (String) -> Void) {
        let gc = CLGeocoder()
        var address = ""
        if let loc = currentLocation {
            gc.reverseGeocodeLocation(loc) { places, _ in
                
                if let foundPlaces = places {
                    let place = foundPlaces[0]
                    address = """
                        \(place.subLocality ?? "")
                        \(place.locality ?? "")
                        \(place.administrativeArea ?? ""), \(place.postalCode ?? "")
                        \(place.country ?? "")
                    """
                    callback(address)
                }
            }
        }
    }
}

extension LocationUtility: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            print("didUpdateLocations: \(loc.coordinate.latitude), \(loc.coordinate.longitude)")
            currentLocation = loc
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            isAuthorized = true
        case .authorizedAlways:
            isAuthorized = true
        default:
            isAuthorized = false
        }
    }
}
