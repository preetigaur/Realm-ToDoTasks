//
//  UsersVC.swift
//  RealmTodo
//
//  Created by Preeti Gaur on 30/09/18.
//  Copyright © 2018 iReka Soft. All rights reserved.
//

import UIKit
import RealmSwift


class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var realm : Realm!
    
    var assigneesList: Results<Assignee> {
        get {
            return realm.objects(Assignee.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Assignees"
        
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kGroupID)!
        let fileURL = directory.appendingPathComponent(kDBName)
        realm = try! Realm(fileURL: fileURL)
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
        let assignee = assigneesList[indexPath.row]
        cell.textLabel!.text = assignee.name
        return cell
    }
    
    // [3]
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // [4]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assigneesList.count
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let assignee = assigneesList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userTasksVC = storyboard.instantiateViewController(withIdentifier: "UserTasksVC") as! UserTasksVC
        userTasksVC.assignee = assignee
        self.navigationController?.pushViewController(userTasksVC, animated: true)
    }
    
}
