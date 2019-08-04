//
//  LessonService.swift
//  KeyStonePark
//
//  Created by soni suman on 03/08/19.
//  Copyright © 2019 soni suman. All rights reserved.
//

import Foundation
import CoreData

class LessonService {
  
 private let moc: NSManagedObjectContext
 private var students =  [Student]()
  
  enum  LessonType: String{
    case ski,snowBoard
  }
  typealias StudentHandler = (Bool,[Student]) -> ()
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
  func addStudent(name:String,for type: LessonType,completion: StudentHandler) {
    let student = Student(context: moc)
    student.name = name
    if let lesson = lessonExist(type) {
      register(student, for: lesson)
      students.append(student)
    }
    completion(true, students)
  }
  //Mark : lesson exist
 private func lessonExist(_ type: LessonType) -> Lesson? {
    let request: NSFetchRequest<Lesson> = NSFetchRequest()
    request.predicate = NSPredicate(format: "type == %@", type.rawValue)
    var lesson: Lesson?
    do {
      let result = try moc.fetch(request)
      lesson = result.isEmpty ? addNew(lesson: type) : result.first
    } catch {
      print("error===\(error.localizedDescription)")
    }
  
  return lesson
  }
  
 private func addNew(lesson type: LessonType) -> Lesson? {
    let lesson = Lesson(context: moc)
    lesson.type = type.rawValue
    return lesson
    
  }
  private func register( _ student: Student, for lesson: Lesson) {
    student.lesson = lesson.type
  }
  func save() {
    do {
      try moc.save()
    } catch  {
      print("error===\(error.localizedDescription)")
    }
  }
  
}
