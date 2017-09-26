//
//  CityWeather.swift
//  cityWeather
//
//  Created by Andrea Agudo on 4/9/17.
//  Copyright © 2017 Andrea Agudo. All rights reserved.
//

import Foundation
import ObjectMapper

class CityWeather: NSObject, Mappable{
    
    var geonames = [Geonames]()
    var totalResultsCount = 0
    
    func mapping(map: Map) {
        
        geonames <- map["geonames"]
        totalResultsCount <- map["totalResultsCount"]
        
    }
    
    required init?(map: Map){
        super.init()
        self.mapping(map: map)
    }
    
    override init() {
        super.init()
    }
    
}


class Geonames: NSObject, Mappable{
    
    var name = ""
    var lat = ""
    var lng = ""
    var bbox = Bbox()
    
    func mapping(map: Map) {
        
        bbox <- map["bbox"]
        name <- map["name"]
        lat <- map["lat"]
        lng <- map["lng"]
    }
    
    required init?(map: Map){
        super.init()
        self.mapping(map: map)
    }
    
    override init() {
        super.init()
    }
    
}

class Bbox: NSObject, Mappable{
    
    var south = 0.0
    var east = 0.0
    var north = 0.0
    var west = 0.0
    
    
    func mapping(map: Map) {
        
        east <- map["east"]
        south <- map["south"]
        north <- map["north"]
        west <- map["west"]
    }
    
    required init?(map: Map){
        super.init()
        self.mapping(map: map)
    }
    
    override init() {
        super.init()
    }
    
}

class CityTemp: NSObject, Mappable{
    
    var weatherObservations = [Temp]()
    
    func mapping(map: Map) {
        
        weatherObservations <- map["weatherObservations"]
        
    }
    
    required init?(map: Map){
        super.init()
        self.mapping(map: map)
    }
    
    override init() {
        super.init()
    }
}

class Temp: NSObject, Mappable{
    
    var temperature = ""
    
    func mapping(map: Map) {
        
        temperature <- map["temperature"]
        
    }
    
    required init?(map: Map){
        super.init()
        self.mapping(map: map)
    }
    
    override init() {
        super.init()
    }
}



