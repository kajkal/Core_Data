//
//  ViewController.swift
//  Core_Data
//
//  Created by kjkl on 12/23/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var dataManager: DataManager?

    @IBOutlet weak var resultsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            dataManager = DataManager(managedObjectContext: appDelegate.persistentContainer.viewContext)
        }
    }
    
    private func printLog(message: String, startTime: NSDate) {
        let measuredTime = abs(startTime.timeIntervalSinceNow)
        let formattedTime = String(format: "%.4f", measuredTime)
        let text = resultsLbl.text ?? ""
        resultsLbl.text = text + "[\(formattedTime)s] \(message)\n"
    }

    @IBAction func generateData(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            dataManager.clearData()
            dataManager.save()
            
            let generateStartTime = NSDate();
            
            let data = dataManager.generateData()
            
            print("Data generated with \(data.readings.count) readings")
            printLog(message: "Data generated with \(data.readings.count) readings", startTime: generateStartTime)
                
            data.sensors.prefix(5).forEach {
                print("Sensor (name='\($0.name)', desc='\($0.desc)')")
                
            }
            print("...")
            data.readings.prefix(5).forEach {
                print("Reading (timestamp=\($0.timestamp), sensorName='\($0.sensor.name)', value=\($0.value))")
            }
            print("...")
            
            let saveStartTime = NSDate();

            dataManager.save()
            
            print("data saved in core data")
            printLog(message: "Data saved in core data", startTime: saveStartTime)
        }
    }
    
    @IBAction func queryMinMaxTime(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let startTime = NSDate();
            
            let (min, max) = dataManager.getMinAndMaxTimestamps()
            let formattedMin = Utils.formatTimestamp(timestamp: min)
            let formattedMax = Utils.formatTimestamp(timestamp: max)
            
            print("Min timestamp='\(formattedMin)', Max timestamp='\(formattedMax)'")
            printLog(message: "Min='\(formattedMin)', Max='\(formattedMax)'", startTime: startTime)
        }
    }
    
    @IBAction func queryAverageValue(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let startTime = NSDate();
            
            let avgValue = dataManager.getAverageReadingValue()
            let formattedAvg = String(format: "%.2f", avgValue)
            
            print("Average reading value='\(formattedAvg)'")
            printLog(message: "Average='\(formattedAvg)'", startTime: startTime)
        }
    }
    
    @IBAction func querySensorAverageValue(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let startTime = NSDate();
            
            for (sensorName, avgAndCount) in dataManager.getAverageReadingValueGroupedBySensor() {
                let formattedCount = String(format: "%3d", avgAndCount.count)
                let formattedAvg = String(format: "%.2f", avgAndCount.avg)

                print("Sensor='\(sensorName)', readingCount=\(formattedCount), avg=\(formattedAvg)")
            }
            
            printLog(message: "Average group by sensor calculated", startTime: startTime)
        }
    }
    
}

