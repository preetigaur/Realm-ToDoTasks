//
//  UserTasksVC.swift
//  RealmTodo
//
//  Created by Preeti Gaur on 30/09/18.
//  Copyright © 2018 iReka Soft. All rights reserved.
//

import UIKit
import RealmSwift

class UserTasksVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var assignee : Assignee!
    var realm : Realm!
    var todoList: List<TodoItem>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User Tasks"
        todoList = assignee.tasks
        // Do any additional setup after loading the view.
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
        let item = todoList![indexPath.row]
        
        cell.textLabel!.text = item.detail
        cell.detailTextLabel!.text = "Status :" + "\(item.status)"
        
        return cell
    }
    
    // [3]
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // [4]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList!.count
    }
}
