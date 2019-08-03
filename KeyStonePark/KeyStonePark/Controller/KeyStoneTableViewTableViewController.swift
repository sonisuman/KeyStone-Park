//
//  KeyStoneTableViewTableViewController.swift
//  KeyStonePark
//
//  Created by soni suman on 03/08/19.
//  Copyright © 2019 soni suman. All rights reserved.
//

import UIKit

class KeyStoneTableViewTableViewController: UITableViewController {
  
   var student = ["Ben","Soni","Rajeev"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
         cell.textLabel?.text = student[indexPath.row]

        return cell
    }
  
  
  private func alertViewController(actionType: String) -> UIAlertController {
    
    let alertController = UIAlertController(title: "KeyStone Park lesson", message: "Student Info", preferredStyle: .alert)
    alertController.addTextField { (textField : UITextField) in
      textField.placeholder = "Stiudent Name"
    }
    alertController.addTextField { (textField: UITextField) in
      textField.placeholder = "Lesson Type: Skill"
      
    }
    let addAction = UIAlertAction(title: actionType.uppercased(), style: .default) { (action) in
    
    }
    let cancelAction =  UIAlertAction.init(title: "Cancel", style: .default) { (action) in
      
    }
    alertController.addAction(addAction)
    alertController.addAction(cancelAction)
    return alertController
  }
  
  @IBAction func addNewLesson(_ sender: UIBarButtonItem) {
    
    present(alertViewController(actionType: "Add"), animated: true, completion: nil)
  }
  

}
