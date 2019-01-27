//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Ido Pesok on 1/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        stopLocationManager()
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let params = ["lat": latitude, "lon": longitude, "appid": API.app_id]
        
        APIServices.shared.getWeatherData(params: params) { (weatherData) in
            self.weatherData = weatherData
            self.updateWeatherData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR COULD NOT GET LOCATION")
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Colors.midnightBlue
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
}
