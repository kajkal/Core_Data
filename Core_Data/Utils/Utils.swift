//
//  Utils.swift
//  Core_Data
//
//  Created by kjkl on 12/23/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import Foundation

struct Utils {
    
    static func generateTimestamp() -> Int {
        // random date between 01-01-2019 and 01-01-2020
        return Int.random(in: 1546300800 ... 1577836800)
    }
    
    static func generateValue() -> Double {
        return Double.random(in: 0 ... 100)
    }
    
    static func formatTimestamp(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd hh:mm"
        
        return dateFormatter.string(from: date)
    }
    
}
