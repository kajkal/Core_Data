//
//  Sensor+CoreDataProperties.swift
//  Core_Data
//
//  Created by kjkl on 12/23/19.
//  Copyright © 2019 kjkl. All rights reserved.
//
//

import Foundation
import CoreData


extension Sensor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sensor> {
        return NSFetchRequest<Sensor>(entityName: "Sensor")
    }

    @NSManaged public var desc: String
    @NSManaged public var name: String
    @NSManaged public var readings: NSSet?

}

// MARK: Generated accessors for readings
extension Sensor {

    @objc(addReadingsObject:)
    @NSManaged public func addToReadings(_ value: Reading)

    @objc(removeReadingsObject:)
    @NSManaged public func removeFromReadings(_ value: Reading)

    @objc(addReadings:)
    @NSManaged public func addToReadings(_ values: NSSet)

    @objc(removeReadings:)
    @NSManaged public func removeFromReadings(_ values: NSSet)

}
