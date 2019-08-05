//
//  LessonService.swift
//  KeyStonePark
//
//  Created by soni suman on 03/08/19.
//  Copyright © 2019 soni suman. All rights reserved.
//

import Foundation
import CoreData

enum  LessonType: String {
  case ski,snowboard
}

class LessonService {
  
  private let moc: NSManagedObjectContext
  private var students = [Student]()
  private var lessons = [Lesson]()
  typealias StudentHandler = (Bool,[Student]) -> ()
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
  
  //Mark: Create
  func addStudent(name:String,for type: LessonType,completion: StudentHandler) {
    let student = Student(context: moc)
    student.name = name
    if let lesson = lessonExist(type) {
      register(student, for: lesson)
      students.append(student)
      completion(true, students)
    }
    save()
  }
  
  //Mark : Read
  func getAllStudents() -> [Student]? {
    let sortByLesson = NSSortDescriptor(key: "lesson.type", ascending: true)
    let sortByName = NSSortDescriptor(key: "name", ascending: true)
    let request: NSFetchRequest<Student> = Student.fetchRequest()
    request.sortDescriptors = [sortByLesson,sortByName]
    do {
      students =  try moc.fetch(request)
      return students
    } catch  {
      print("Error ===\(error.localizedDescription)")
    }
    return nil
  }
  
  //Mark: update
  func updateStudentInfo(currentStudent student: Student , withName name: String, forLesson lesson: String) {
    //check student current lesson == new lesson
    
    if student.lesson?.type?.caseInsensitiveCompare(lesson) == .orderedSame {
      let lesson = student.lesson
      let stuList = Array (lesson?.students?.mutableCopy() as! NSMutableSet) as! [Student]
      
      if let indexValue = stuList.firstIndex(where: {$0 == student}) {
        stuList[indexValue].name = name
        lesson?.students = NSSet(array: stuList)
      }
    }
    else {
      if let lesson = lessonExist(LessonType(rawValue: lesson) ?? LessonType.ski) {
        lesson.removeFromStudents(student)
        student.name = name
        register(student, for: lesson)
      }
    }
    save()
  }
  
  //Mark: Delete
  
  func deletStudent(student: Student) {
    let lesson = student.lesson
    students = students.filter({$0 != student})
    lesson?.removeFromStudents(student)
    moc.delete(student)
    save()
  }
  
  func deletLesson(lesson: Lesson,deleteHandler: @escaping ((Bool) -> Void)) {
    moc.delete(lesson)
    save(completion: deleteHandler)
  }
  
  //Mark: get lesson
  
  func getAvailableLesson() -> [Lesson]? {
    let sortByLesson = NSSortDescriptor(key: "type", ascending: true)
    let sortDescriptor = [sortByLesson]
    let request: NSFetchRequest<Lesson> = Lesson.fetchRequest()
    request.sortDescriptors = sortDescriptor
    do {
      lessons = try  moc.fetch(request)
      return lessons
    } catch {
      print("error===\(error.localizedDescription)")
    }
    return nil
  }
  
  //Mark : lesson exist
  private func lessonExist(_ type: LessonType) -> Lesson? {
    let request: NSFetchRequest<Lesson> = Lesson.fetchRequest()
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
    student.lesson = lesson
  }
  func save(completion: ((Bool) -> Void)? = nil) {
    var success : Bool?
    do {
      try moc.save()
      success = true
    } catch  {
      print("error===\(error.localizedDescription)")
      success = false
      moc.rollback()
    }
    if let completion = completion {
      completion(success ?? false)
    }
  }
  
}
