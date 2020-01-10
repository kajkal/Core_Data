//
//  DataManager.swift
//  Core_Data
//
//  Created by kjkl on 12/23/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func clearData() {
        let (sensors, readings) = loadData()
        sensors.forEach { managedObjectContext.delete($0) }
        readings.forEach { managedObjectContext.delete($0) }
        save()
    }
    
    func generateData() -> (sensors: [Sensor], readings: [Reading]) {
        let sensorCount = 20
        let readingsCount = 20
        
        let sensors: [Sensor] = Array(1...sensorCount).map {
            let newSensor = Sensor(context: managedObjectContext)
            newSensor.name = "S\(String(format: "%02d", $0))"
            newSensor.desc = "Sensor number \($0)"
            return newSensor
        }
        let readings: [Reading] = Array(1...readingsCount).map {_ in
            let newReading = Reading(context: managedObjectContext)
            newReading.timestamp = Int64(Utils.generateTimestamp())
            newReading.sensor = sensors[Int.random(in: 0 ..< sensorCount)]
            newReading.value = Utils.generateValue()
            return newReading
        }
        
        return (
            sensors: sensors,
            readings: readings
        )
    }
    
    func save() {
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Cound not save data. \(error), \(error.userInfo)")
        }
    }
    
    func getMinAndMaxTimestamps() -> (min: Int, max: Int) {
        let minExpression = NSExpressionDescription()
        minExpression.name = "min"
        minExpression.expression = NSExpression(format: "@min.timestamp")
        minExpression.expressionResultType = .integer64AttributeType
        
        let maxExpression = NSExpressionDescription()
        maxExpression.name = "max"
        maxExpression.expression = NSExpression(format: "@max.timestamp")
        maxExpression.expressionResultType = .integer64AttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [minExpression, maxExpression]
                
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            assert(result.count == 1, "Expected 1 result row, but got \(result.count)")
            if let dict = result[0] as? [String: Int] {
                return (min: dict["min"]!, max: dict["max"]!)
            }
        } catch let error as NSError {
            print("Cound not fetch data. \(error), \(error.userInfo)")
        }
        
        return (min: -1, max: -1)
    }
    
    func getAverageReadingValue() -> Double {
        let valueKeyPath = NSExpression(forKeyPath: "value")
        
        let avgExpression = NSExpressionDescription()
        avgExpression.name = "avg"
        avgExpression.expression = NSExpression(forFunction: "average:", arguments: [valueKeyPath])
        avgExpression.expressionResultType = .doubleAttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [avgExpression]
                
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            assert(result.count == 1, "Expected 1 result row, but got \(result.count)")
            if let dict = result[0] as? [String: Double] {
                return dict["avg"]!
            }
        } catch let error as NSError {
            print("Cound not fetch data. \(error), \(error.userInfo)")
        }
        
        return -1
    }
    
    func getAverageReadingValueGroupedBySensor() -> [String: (avg: Double, count: Int)] {
        var sensorValues = [String: (avg: Double, count: Int)]()
        
        let valueKeyPath = NSExpression(forKeyPath: "value")
        
        let avgExpression = NSExpressionDescription()
        avgExpression.name = "avg"
        avgExpression.expression = NSExpression(forFunction: "average:", arguments: [valueKeyPath])
        avgExpression.expressionResultType = .doubleAttributeType
        
        let countExpression = NSExpressionDescription()
        countExpression.name = "count"
        countExpression.expression = NSExpression(forFunction: "count:", arguments: [valueKeyPath])
        countExpression.expressionResultType = .integer64AttributeType
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToGroupBy = ["sensor.name"]
        fetchRequest.propertiesToFetch = ["sensor.name", avgExpression, countExpression]
        fetchRequest.resultType = .dictionaryResultType
                
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            
            if let results = results as? [NSDictionary] {
//                print("results: \(results)")
                
                for dict in results {
                    if let sensorName = dict["sensor.name"] as? String,
                       let avgValue = dict["avg"] as? Double,
                       let valueCount = dict["count"] as? Int {
                        sensorValues[sensorName] = (avg: avgValue, count: valueCount)
                    }
                }
            }
        } catch let error as NSError {
            print("Cound not fetch data. \(error), \(error.userInfo)")
        }
     
        return sensorValues
    }
    
    func loadData() -> (sensors: [Sensor], readings: [Reading]) {
        return (
            sensors: readAllSensorsRows(),
            readings: readAllReadingRows()
        )
    }
    
    private func readAllSensorsRows() -> [Sensor] {
        let fetchRequest: NSFetchRequest<Sensor> = Sensor.fetchRequest()
        
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Cound not fetch data. \(error), \(error.userInfo)")
            return []
        }
    }
    
    private func readAllReadingRows() -> [Reading] {
        let fetchRequest: NSFetchRequest<Reading> = Reading.fetchRequest()
        
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Cound not fetch data. \(error), \(error.userInfo)")
            return []
        }
    }
    
}
