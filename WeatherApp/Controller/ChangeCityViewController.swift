//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Ido Pesok on 1/26/19.
//  Copyright © 2019 IdoPesok. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCity(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var changeCityDelegate: ChangeCityDelegate?
    
    private let cityTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = Colors.wetAsphalt
        tf.textColor = .white
        tf.placeholder = "City..."
        
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 60))
        tf.leftView = leftView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    lazy private var getWeatherButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.blue
        button.setTitle("Get Weather", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        button.addTarget(self, action: #selector(handleGetWeather), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var backButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.midnightBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
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
        [cityTextField, getWeatherButton, backButton].forEach({ view.addSubview($0) })
        
        // CITY TEXT FIELD
        cityTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100).isActive = true
        cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        cityTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // GET WEATHER BUTTON
        getWeatherButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10).isActive = true
        getWeatherButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        getWeatherButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        getWeatherButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // BACK BUTTON
        backButton.topAnchor.constraint(equalTo: getWeatherButton.bottomAnchor, constant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private var colorNum = 1
    fileprivate func setupColorTimer() {
        let _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (_) in
            switch (self.colorNum) {
            case 0:
                self.animateButtonColorChange(toColor: Colors.blue)
                break;
            case 1:
                self.animateButtonColorChange(toColor: Colors.purple)
                break;
            default:
                self.animateButtonColorChange(toColor: Colors.red)
                break;
            }
            
            self.colorNum = (self.colorNum + 1) % 3
        }
    }
    
    private func animateButtonColorChange(toColor: UIColor) {
        UIView.animate(withDuration: 1.0) {
            self.getWeatherButton.backgroundColor = toColor
        }
    }
    
    fileprivate func hideNavBar(value: Bool) {
        self.navigationController?.isNavigationBarHidden = value
    }
    
    @objc func handleGetWeather() {
        guard let text = cityTextField.text else { return }
        changeCityDelegate?.userEnteredANewCity(city: text)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
