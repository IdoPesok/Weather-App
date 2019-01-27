//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ido Pesok on 1/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, ChangeCityDelegate {

    var weatherData: WeatherData?
    
    let locationManager = CLLocationManager()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.clouds
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.blue
        label.font = UIFont.boldSystemFont(ofSize: 120)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleSwitchTempUnit))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    lazy private var searchByCityButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.wetAsphalt
        button.setTitle("Search By City", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        button.addTarget(self, action: #selector(handleSearchByCity), for: .touchUpInside)

        return button
    }()
    
    private var tempUnit = TempUnit.fahrenheit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLocationManager()
        setupColorTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavBar(value: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideNavBar(value: false)
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Colors.midnightBlue
        
        // ADD SUBVIEWS
        [locationLabel, tempLabel, iconImageView, searchByCityButton].forEach({ view.addSubview($0) })
        
        // LOCATION LABEL
        locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        // ICON IMAGE VIEW
        iconImageView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ((view.frame.width / 5 * 4) / 2)).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -((view.frame.width / 5 * 4) / 2)).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: (view.frame.width / 5)).isActive = true
        
        // TEMP LABEL
        tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        // SEARCH BY CITY BUTTON
        searchByCityButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        searchByCityButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        searchByCityButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        searchByCityButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private var colorNum = 1
    fileprivate func setupColorTimer() {
        let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (_) in
            switch (self.colorNum) {
            case 0:
                self.animateTempLabelColorChange(toColor: Colors.blue)
                break;
            case 1:
                self.animateTempLabelColorChange(toColor: Colors.purple)
                break;
            default:
                self.animateTempLabelColorChange(toColor: Colors.red)
                break;
            }
            
            self.colorNum = (self.colorNum + 1) % 3
        }
    }
    
    private func animateTempLabelColorChange(toColor: UIColor) {
        UIView.animate(withDuration: 1.0) {
            self.tempLabel.textColor = toColor
        }
    }
    
    func updateWeatherData() {
        guard let weatherData = weatherData else { return }
        
        if weatherData.getName() == "ERROR" {
            self.locationLabel.text = "Unavailible"
            self.tempLabel.text = "NA"
        } else {
            self.locationLabel.text = weatherData.getName()
            self.tempLabel.text = "\(weatherData.getFarenTemp())°F"
            self.iconImageView.image = UIImage.init(named: weatherData.getWeatherIconName())
        }
    }
    
    @objc func handleSwitchTempUnit() {
        guard let data = weatherData else { return }
        
        if tempUnit == .celcius {
            tempLabel.text = "\(data.getFarenTemp())°F"
            tempUnit = .fahrenheit
        } else {
            tempUnit = .celcius
            tempLabel.text = "\(data.getCelsTemp())°C"
        }
    }
    
    fileprivate func hideNavBar(value: Bool) {
        self.navigationController?.isNavigationBarHidden = value
    }
    
    @objc func handleSearchByCity() {
        let vc = ChangeCityViewController()
        vc.changeCityDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func userEnteredANewCity(city: String) {
        let params = ["q" : city, "appid" : API.app_id]
        
        APIServices.shared.getWeatherData(params: params) { (weatherData) in
            self.weatherData = weatherData
            self.updateWeatherData()
        }
    }
    
}

