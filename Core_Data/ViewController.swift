//
//  ViewController.swift
//  Core_Data
//
//  Created by kjkl on 12/23/19.
//  Copyright © 2019 kjkl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dataManager: DataManager?

    @IBOutlet weak var resultsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
    }
    
    private func printLog(message: String, startTime: NSDate) {
        let measuredTime = abs(startTime.timeIntervalSinceNow)
        let formattedTime = String(format: "%.4f", measuredTime)
        let text = resultsLbl.text ?? ""
        resultsLbl.text = text + "[\(formattedTime)s] \(message)\n"
    }

    @IBAction func generateData(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let generateStartTime = NSDate()
            
        }
    }
    
    @IBAction func queryMinMaxTime(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let generateStartTime = NSDate()
            
        }
    }
    @IBAction func queryAverageValue(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let generateStartTime = NSDate()
            
        }
    }
    @IBAction func querySensorAverageValue(_ sender: UIButton) {
        if let dataManager = self.dataManager {
            let generateStartTime = NSDate()
            
        }
    }
    
}

