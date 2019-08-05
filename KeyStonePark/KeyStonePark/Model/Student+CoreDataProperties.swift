//
//  Student+CoreDataProperties.swift
//  KeyStonePark
//
//  Created by Soni Suman on 8/5/19.
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
    @NSManaged public var lesson: Lesson?

}
