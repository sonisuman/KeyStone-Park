//
//  KeyStoneTableViewTableViewController.swift
//  KeyStonePark
//
//  Created by soni suman on 03/08/19.
//  Copyright © 2019 soni suman. All rights reserved.
//

import UIKit
import CoreData

class KeyStoneTableViewTableViewController: UITableViewController {
  var moc : NSManagedObjectContext? {
    didSet {
      if let moc = moc {
        lessonService = LessonService(moc: moc)
      }
    }
  }
  
  private var lessonService: LessonService?
  private var studentList = [Student]()
  private var studentTobeUpdate : Student?
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadAllStudents()
  }
  
  @IBAction func addNewLesson(_ sender: UIBarButtonItem) {
    
    present(alertViewController(actionType: "Add"), animated: true, completion: nil)
  }
  
  @IBAction func lessonBtnPressed(_ sender: UIBarButtonItem) {
  }
  func loadAllStudents() {
    if let students = lessonService?.getAllStudents()  {
      studentList = students
      tableView.reloadData()
    }
  }
}
extension KeyStoneTableViewTableViewController {
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return studentList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
    cell.textLabel?.text = studentList[indexPath.row].name
    cell.detailTextLabel?.text = studentList[indexPath.row].lesson?.type
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    studentTobeUpdate = studentList[indexPath.row]
    present(alertViewController(actionType: "Update"), animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      lessonService?.deletStudent(student: studentList[indexPath.row])
      studentList.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .left)
      tableView.reloadData()
    }
  }
}
extension KeyStoneTableViewTableViewController {
  
  private func alertViewController(actionType: String) -> UIAlertController {
    
    let alertController = UIAlertController(title: "KeyStone Park lesson", message: "Student Info", preferredStyle: .alert)
    alertController.addTextField { [weak self](textField : UITextField) in
      textField.placeholder = "Stiudent Name"
      textField.text = self?.studentTobeUpdate?.name  == nil ? "" : self?.studentTobeUpdate?.name
    }
    alertController.addTextField {[weak self] (textField: UITextField) in
      textField.placeholder = "Lesson Type: Ski | snowBoard"
      textField.text = self?.studentTobeUpdate?.lesson?.type == nil ? "" : self?.studentTobeUpdate?.lesson?.type
    }
    let addAction = UIAlertAction(title: actionType.uppercased(), style: .default) { [weak self](action) in
      
      guard let name = alertController.textFields?[0].text , let lesson = alertController.textFields?[1].text  else {return}
      if actionType.caseInsensitiveCompare("add")  == .orderedSame {
        if let lessonValue = LessonType(rawValue: lesson.lowercased()) {
          self?.lessonService?.addStudent(name: name, for: lessonValue, completion: { (success, students) in
            if success {
              self?.studentList = students
            }
          })
        }
      }
      else {
        guard let name = alertController.textFields?[0].text, !name.isEmpty,let studentToUpadte = self?.studentTobeUpdate, let lesson = alertController.textFields?[1].text  else {return}
        if actionType.caseInsensitiveCompare("update") == .orderedSame {
          self?.lessonService?.updateStudentInfo(currentStudent: studentToUpadte, withName: name, forLesson: lesson)
          self?.studentTobeUpdate = nil
        }
      }
      DispatchQueue.main.async {
        self?.loadAllStudents()
      }
    }
    
    let cancelAction =  UIAlertAction.init(title: "Cancel", style: .default) {[weak self](action) in
      self?.studentTobeUpdate = nil
    }
    alertController.addAction(addAction)
    alertController.addAction(cancelAction)
    return alertController
  }
}
