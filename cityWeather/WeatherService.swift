//
//  WeatherService.swift
//  cityWeather
//
//  Created by Andrea Agudo on 4/9/17.
//  Copyright © 2017 Andrea Agudo. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class WeatherService : NSObject {
    
    var properties: NSDictionary!
    
    func getLocation(parameters : [String: String],completion: @escaping (_ response: AnyObject?) -> ()){
        
        if let path = Bundle.main.path(forResource: "APIProperties", ofType: "plist") {
            properties = NSDictionary(contentsOfFile: path)
        }
        
        var parameter2 : [String: String]? = ["maxRows": "20" as String , "startRow" : "0" as String, "lang" : "en" as String, "isNameRequired" : "true" as String, "username" : "ilgeonamessample" as String, "style": "FULL" as String]
        
        
        parameter2?.merge(dict: parameters)
        print("Parametros: " + String(describing: parameter2))
        
        Alamofire
            .request(properties.object(forKey: "urlLocation") as! String, method: .post, parameters: parameter2, encoding: URLEncoding.default, headers: nil)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    completion(value as AnyObject)
                    
                //print(response)
                    
                    
                case .failure(let error):
                    completion(error as AnyObject)
                    print("Algo ha ido mal")
                }
                
        }
        
    }
    
    func getLocationMapped(city : String, completion:@escaping (_ response: () throws ->  CityWeather?) -> Void){
        
        getLocation(parameters: ["q" : city as String], completion: { (response) in
            let result = response as? [String: AnyObject]
            
            if(result?["geonames"] != nil){
                let map = Map.init(mappingType: MappingType.fromJSON, JSON: result!)
                let resultMap = CityWeather(map: map)
                
                completion({return resultMap})
            }
            else{
                completion({return nil})
            }
     
        })
    }
    
    func getWeather(parameters : [String: String],completion: @escaping (_ response: AnyObject?) -> ()){
        
        if let path = Bundle.main.path(forResource: "APIProperties", ofType: "plist") {
            properties = NSDictionary(contentsOfFile: path)
        }
        
        var parameter2 : [String: String]? = ["username" : "ilgeonamessample" as String]
        
        
        parameter2?.merge(dict: parameters)
        print("Parametros: " + String(describing: parameter2))
        
        Alamofire
            .request(properties.object(forKey: "urlWeather") as! String, method: .post, parameters: parameter2, encoding: URLEncoding.default, headers: nil)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    completion(value as AnyObject)
                    
                    //print(response)
                    
                    
                case .failure(let error):
                    completion(error as AnyObject)
                    print("Algo ha ido mal")
                }
                
        }
        
    }
    
    func getWeatherMapped(north : String, west : String, south : String, east : String, completion:@escaping (_ response: () throws ->  CityTemp?) -> Void){
        
        getWeather(parameters: ["north" : north as String,"west" : west as String, "east" : east as String, "south" : south as String ], completion: { (response) in
            let result = response as? [String: AnyObject]
            
            if(result?["weatherObservations"] != nil){
                let map = Map.init(mappingType: MappingType.fromJSON, JSON: result!)
                let resultTemp = CityTemp(map: map)
                
                completion({return resultTemp})
            }
            else{
                completion({return nil})
            }
            
        })
    }
    
}
