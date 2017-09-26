//
//  Merge.swift
//  cityWeather
//
//  Created by Andrea Agudo on 6/9/17.
//  Copyright © 2017 Andrea Agudo. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}
