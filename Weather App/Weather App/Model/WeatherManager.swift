//
//  WeatherManager.swift
//  Weather App
//
//  Created by Aurelio Le Clarke on 31.01.2022.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=cd42afe71ef146efab5807f077330243&units=metric"
    
    var delegate: WeatherManagerDelegate?

    //соединяем город с API, включаем метод performRequest
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        self.performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //работа с сетью. Настраиваем URL,
    func performRequest(with urlString: String) {
       //create a URL
        guard let url = URL(string: urlString) else {return}
       //Create a URL session
        let session = URLSession(configuration: .default)
      //give the task
        let task = session.dataTask(with: url) { data, response, error in
            if  error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            if let safeData = data {
                if let weather = self.parseJSON(weatherData: safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
       //start the task
        task.resume()
    }
   //Парсим JSON
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            
      let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            print(weather.temperature)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
   
    
    }
    
    }




