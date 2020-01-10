//
//  Reading+CoreDataProperties.swift
//  Core_Data
//
//  Created by kjkl on 12/23/19.
//  Copyright © 2019 kjkl. All rights reserved.
//
//

import Foundation
import CoreData


extension Reading {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reading> {
        return NSFetchRequest<Reading>(entityName: "Reading")
    }

    @NSManaged public var timestamp: Int64
    @NSManaged public var value: Double
    @NSManaged public var sensor: Sensor?

}
