//
//  UserRecipe+CoreDataProperties.swift
//  RESTInteract
//
//  Created by Akshay  on 11/06/2017.
//  Copyright © 2017 Akshay . All rights reserved.
//

import Foundation
import CoreData


extension UserRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserRecipe> {
        return NSFetchRequest<UserRecipe>(entityName: "UserRecipe")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var ingredients: String?
    @NSManaged public var name: String?

}
