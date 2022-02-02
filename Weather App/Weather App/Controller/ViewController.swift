//
//  ViewController.swift
//  Weather App
//
//  Created by Aurelio Le Clarke on 31.01.2022.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate  {
    
    
    
   
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
   
    
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var CurrentDegree: UILabel!
    @IBOutlet weak var WeatherImage: UIImageView!
    
  
    @IBAction func LocationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        TextField.endEditing(true)
        print(TextField.text!)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print(TextField.text!)
        TextField.endEditing(true)
        return true
    }

    //закрывается клава когда пользователь нажимать enter
    func textFieldDidEndEditing(_ textField: UITextField) {
        //опциональное развертывание города
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        TextField.text = ""
            
}
    
    //если пользователь ничего не пишет
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if TextField.text != "" {
                return true
        } else {
            TextField.placeholder = "Type something"
            return false
        }
    }

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.CurrentDegree.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.WeatherImage.image = UIImage(systemName: weather.conditionName)
        }
        
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
extension ViewController: CLLocationManagerDelegate {
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
