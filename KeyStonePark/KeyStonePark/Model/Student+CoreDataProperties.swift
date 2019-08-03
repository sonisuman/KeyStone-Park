//
//  Student+CoreDataProperties.swift
//  KeyStonePark
//
//  Created by soni suman on 03/08/19.
//  Copyright © 2019 soni suman. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var lesson: String?
    @NSManaged public var lessons: Student?

}
