//
//  LessonDetailsTableViewController.swift
//  KeyStonePark
//
//  Created by Soni Suman on 8/5/19.
//  Copyright © 2019 soni suman. All rights reserved.
//

import UIKit
import  CoreData

class LessonDetailsTableViewController: UITableViewController {
  
  var moc : NSManagedObjectContext? {
    didSet {
      if let moc = moc {
        lessonService = LessonService(moc: moc)
      }
    }
  }
  private var lessons = [Lesson]()
  private var lessonService : LessonService?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let appdelegate = (UIApplication.shared.delegate) as! AppDelegate
    moc =  appdelegate.persistentContainer.viewContext
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let availableLesson = lessonService?.getAvailableLesson() {
      lessons = availableLesson
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return lessons.count
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
    cell.textLabel?.text = lessons[indexPath.row].type
    return cell
  }
  
  // Override to support editing the table view.
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      lessonService?.deletLesson(lesson: lessons[indexPath.row], deleteHandler: { [weak self](success) in
        if success {
          self?.lessons.remove(at: indexPath.row)
          self?.tableView.deleteRows(at: [indexPath], with: .left)
        }
        else {
          let alertController = UIAlertController(title: "Delete Failed", message: "There are students currently register for this lesson. ", preferredStyle: .alert)
          let action = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(action)
          self?.present(alertController, animated: true, completion: nil)
        }
      })
      tableView.reloadData()
    }
  }
}
