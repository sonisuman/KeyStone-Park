//
//  Lesson+CoreDataProperties.swift
//  KeyStonePark
//
//  Created by Soni Suman on 8/5/19.
//  Copyright © 2019 soni suman. All rights reserved.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var type: String?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for students
extension Lesson {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}
