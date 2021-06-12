//
//  WeatherManager.swift
//  Clima
//
//  Created by Slava on 18.02.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager  {
 
    var delegate : WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=c981de3947399556eab725957712f6ac&units=metric"

func fetchWeather(cityName: String) {
    let urlString = "\(weatherURL)&q=\(cityName)"
    performRequest(with: urlString)
}
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees ) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
//        1. Create a URL
        
        if let url = URL(string: urlString) {
//            2. Create a URLSession
        let session = URLSession(configuration: .default)
//            3. Give the session a task
        let task = session.dataTask(with: url) { (data, responce, error) in
                
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let weather = parseJSON(safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
//            4. Start the task
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            print(decodedData.main.temp)
           let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
          let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
//            print(weather.temperatureString)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
    
    
    
    
    
    
    
    
    
//    func handle(data: Data?, responce: URLResponse?, error: Error?){
//        if error != nil {
//            print("error")
//            return
//        }
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//        }
//    }

