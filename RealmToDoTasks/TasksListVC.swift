//
//  TasksListVC.swift
//  RealmTodo
//
//  Created by Preeti Gaur on 30/09/18.
//  Copyright © 2018 Preeti Gaur. All rights reserved.
//

import UIKit
import RealmSwift

class TasksListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var realm : Realm!
  
  var todoList: Results<TodoItem> {
    get {
      return realm.objects(TodoItem.self)
    }
  }
    
    var assigneesList: Results<Assignee> {
        get {
            return realm.objects(Assignee.self)
        }
    }
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.title = "Tasks List"
    
    let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kGroupID)!
    let fileURL = directory.appendingPathComponent(kDBName)
    realm = try! Realm(fileURL: fileURL)
    addRightBarButton()

  }
    
    func addRightBarButton() {
        let rightButtonItem = UIBarButtonItem.init(
            title: "Users",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let usersVC = storyboard.instantiateViewController(withIdentifier: "UsersVC") as! UsersVC
        self.navigationController?.pushViewController(usersVC, animated: true)
    }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewDataSource
  // [2]
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                               reuseIdentifier: "Cell")
    let item = todoList[indexPath.row]
    
    cell.textLabel!.text = item.detail
    cell.detailTextLabel!.text = "Assigned To :" + "\(String(describing: item.owner.name))   " + "Status :" + "\(item.status)"
    
    return cell
  }
  
  // [3]
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  // [4]
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.count
  }

  @IBAction func addNew(_ sender: Any) {
    
    let alertController : UIAlertController = UIAlertController(title: "New Todo", message: "What do you plan to do?", preferredStyle: .alert)
    
    alertController.addTextField { (taskTextField) in
      taskTextField.placeholder = "Task Name"
    }
    
    alertController.addTextField { (assigneeTextField) in
        assigneeTextField.placeholder = "Assigned To"
    }
    
    let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) -> Void in
      
    }
    alertController.addAction(action_cancel)
    
    let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
        
        let taskTextField = (alertController.textFields?.first)! as UITextField
        let assigneeNameTextField = alertController.textFields![1] as UITextField
        
        let taskDesc = taskTextField.text
        let assigneeName = assigneeNameTextField.text
        
        if (taskDesc?.trimmingCharacters(in: .whitespaces) != "") &&
            (assigneeName?.trimmingCharacters(in: .whitespaces) != "") {
           
            let todoItem = TodoItem() // [1]
            todoItem.detail = taskDesc!
            todoItem.status = 0
            
            
            let assigneeList = self.realm.objects(Assignee.self).filter("name = %@", assigneeNameTextField.text!)
            var assignee : Assignee = Assignee()
            if assigneeList.count > 0 {
                
                assignee = assigneeList[0]
            } else {
                assignee = Assignee()
                assignee.name = assigneeName!
            }
            
            todoItem.owner = assignee
            
            try! self.realm.write({ // [2]
                
                assignee.tasks.append(todoItem)
                self.realm.add(todoItem)
                //self.realm.add(assignee)
                self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
            })

        }
    }
    
    alertController.addAction(action_add)
    
    present(alertController, animated: true, completion: nil)
    
  }

  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let item = todoList[indexPath.row]
    try! self.realm.write({
      if (item.status == 0){
        item.status = 1
      }else{
        item.status = 0
      }
    })
    tableView.reloadRows(at: [indexPath], with: .automatic)

  }
  // [1]
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // [2]
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if (editingStyle == .delete){
      let item = todoList[indexPath.row]
      try! self.realm.write({
        self.realm.delete(item)
      })
      
      tableView.deleteRows(at:[indexPath], with: .automatic)
      
    }
    
  }

}

