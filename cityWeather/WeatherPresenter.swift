//
//  WeatherPresenter.swift
//  cityWeather
//
//  Created by Andrea Agudo on 4/9/17.
//  Copyright © 2017 Andrea Agudo. All rights reserved.
//

import Foundation

struct MapData{
    var name: String = ""
    var lat: String = ""
    var lng: String = ""
}

protocol WeatherView {
    func locationDataRecieved()
    func setData(_ data: MapData)
    func error()
}

class WeatherPresenter {
    
    var cityTextField : String = ""
    var locationResult = CityWeather()
    var locationFinal = Geonames()
    var weatherResult = CityTemp()
    var totalTemp: Double = 0.0
    
  
    var totalResultsCount: Int! = 0
    
    var north: String = ""
    var east: String = ""
    var west: String = ""
    var south: String = ""
    
    var averageTemp : Double = 0.0
    
    let weatherService: WeatherService
    var weatherView : WeatherView?
    
    
    init(weatherService: WeatherService){
        self.weatherService = weatherService
    }
    
    func attachView(_ view:WeatherView){
        weatherView = view
    }
    
    func detachView() {
        weatherView = nil
    }
    
    func getLocation(){
        weatherService.getLocationMapped(city: cityTextField) { response in
            self.checkLocation(data: response)
        }
        
    }
    
    func checkLocation(data: () throws -> CityWeather?){
        do{
            let result = try data()
            if ( result != nil) {
                self.locationResult = result!
                print("totalResultsCount: " + String(self.locationResult.totalResultsCount))
                
                self.totalResultsCount = self.locationResult.totalResultsCount
                
                if self.locationResult.totalResultsCount > 0 {
                    self.locationFinal = self.locationResult.geonames[0]
                    
                    let mappedData = result.map{_ in 
                        return MapData(name: self.locationFinal.name, lat: self.locationFinal.lat, lng: self.locationFinal.lng)
                    }
                    
                    self.weatherView?.setData(mappedData!)
                
                    self.south = String(self.locationFinal.bbox.south)
                    self.west = String(self.locationFinal.bbox.west)
                    self.east = String(self.locationFinal.bbox.east)
                    self.north = String(self.locationFinal.bbox.north)

                    self.locationResult = CityWeather()
                    self.locationFinal = Geonames()
                    
                    self.weatherView?.locationDataRecieved()
                    
                }else{
                    self.weatherView?.error()
                }
                
            }
            
        }catch _{
            print("Se ha producido un error")
        }
    }
    
    func getWeather() {
        weatherService.getWeatherMapped(north: self.north, west: self.west, south: self.south, east: self.east){ response in
            self.checkWeather(data: response)
        }
    }
    
    
    func checkWeather(data: () throws -> CityTemp?){
        do{
            let result = try data()
            if ( result != nil) {
                self.weatherResult = result!
                
                for i in 0 ..< self.weatherResult.weatherObservations.count  {
                    totalTemp += Double(self.weatherResult.weatherObservations[i].temperature)!
                    print("Temperatura " + String(i) + ": " + self.weatherResult.weatherObservations[i].temperature)
                }

                averageTemp = totalTemp / Double(self.weatherResult.weatherObservations.count)
                totalTemp = 0.0
                
                print("Tempertatura media: " + String(averageTemp))
                
                
            }else{
                
            }
            
        }catch _{
            print("Se ha producido un error")
        }
    }
    
}
