//
//  Waste+CoreDataProperties.swift
//  RESTInteract
//
//  Created by Akshay  on 12/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import Foundation
import CoreData


extension Waste {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Waste> {
        return NSFetchRequest<Waste>(entityName: "Waste")
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var weight: Int16

}
