//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Ido Pesok on 1/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import SwiftyJSON

struct WeatherData {
    
    private var name: String
    private var f_temp: Int
    private var c_temp: Int
    private var weatherIconName: String
    
    init(json: JSON) {
        guard let name = json["name"].string, let temp = json["main"]["temp"].double, let condition = json["weather"][0]["id"].int else {
            self.name = "ERROR"
            self.f_temp = 0
            self.c_temp = 0
            self.weatherIconName = "ERROR"
            
            return
        }
        
        self.name = name
        self.f_temp = Int.init(temp * (9/5) - 459.67)
        self.c_temp = Int.init(temp - 273.15)
        
        self.weatherIconName = "NIL"
        self.setWeatherIconName(conditionId: condition)
    }
    
    private mutating func setWeatherIconName(conditionId: Int) {
        switch (conditionId) {
            case 0...300 :
                self.weatherIconName = "tstorm1"
            case 301...500 :
                self.weatherIconName = "light_rain"
            case 501...600 :
                self.weatherIconName = "shower3"
            case 601...700 :
                self.weatherIconName = "snow4"
            case 701...771 :
                self.weatherIconName = "fog"
            case 772...799 :
                self.weatherIconName = "tstorm3"
            case 800 :
                self.weatherIconName = "sunny"
            case 801...804 :
                self.weatherIconName = "cloudy2"
            case 900...903, 905...1000  :
                self.weatherIconName = "tstorm3"
            case 903 :
                self.weatherIconName = "snow5"
            case 904 :
                self.weatherIconName = "sunny"
            default :
                self.weatherIconName = "dunno"
        }
    }
    
    func getWeatherIconName() -> String {
        return weatherIconName
    }
    
    func getName() -> String {
        return name 
    }
    
    func getFarenTemp() -> Int {
        return f_temp
    }
    
    func getCelsTemp() -> Int {
        return c_temp
    }
    
}

enum TempUnit: String {
    case fahrenheit, celcius
}
