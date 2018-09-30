//
//  Assignee.swift
//  RealmTodo
//
//  Created by Preeti Gaur on 30/09/18.
//  Copyright © 2018 Preeti Gaur. All rights reserved.
//

import RealmSwift

class Assignee: Object {
    
    @objc dynamic var name = ""
    let tasks = List<TodoItem>()
}
