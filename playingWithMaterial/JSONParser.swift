//
//  JSONParser.swift
//  playingWithMaterial
//
//  Created by Anne Cahalan on 2/9/16.
//  Copyright © 2016 Anne Cahalan. All rights reserved.
//

import Foundation

class JSONParser {
    
    typealias JSONDictionary = [String: AnyObject]
    
    struct location {
        var city: String?
        var weatherDescription: String?
        var tempF: Int?
        var tempStringF: String?
        var windMPH:Int?
    }
   
    func pinged() -> String {
        return "Hit the parser!"
    }
    
    func parseDictionary(json: AnyObject) -> location {
        var currentLocation: location = location()
        if let currentObservationDictionary = json["current_observation"] {
            
            if let displayLocationDictionary = currentObservationDictionary?["display_location"] {
                
                if let city = displayLocationDictionary?["city"] as? String {
                    print("City: \(city)")
                    currentLocation.city = city
                }
                
                if let weatherDescription =  currentObservationDictionary?["weather"] as? String {
                    print("Weather: \(weatherDescription)")
                    currentLocation.weatherDescription = weatherDescription
                }
                
                if let tempF = currentObservationDictionary?["temp_f"] as? Int {
                    print("Temp: \(tempF)")
                    currentLocation.tempF = tempF
                    currentLocation.tempStringF = "\(tempF)"
                }
                
                if let windMPH = currentObservationDictionary?["wind_gust_mph"] as? Int {
                    print("wind speed: \(windMPH)")
                    currentLocation.windMPH = windMPH
                }
                
            }
            
        }
        
        return location
    }
    
}