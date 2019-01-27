//
//  APIServices.swift
//  WeatherApp
//
//  Created by Ido Pesok on 1/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIServices {
    
    static let shared = APIServices()
    
    func getWeatherData(params: [String: String], completion: @escaping (WeatherData) -> Void) {
        Alamofire.request(API.url, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess, let value = response.result.value {
                let weatherJSON = JSON.init(value)
                let weatherData = WeatherData.init(json: weatherJSON)
                
                completion(weatherData)
            } else {
                print("CONNECTION ISSUES")
            }
        }
    }
    
}
