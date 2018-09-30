//
//  TodoItem.swift
//  RealmTodo
//
//  Created by Preeti Gaur on 30/09/18.
//  Copyright © 2018 Preeti Gaur. All rights reserved.
//

import RealmSwift


class TodoItem: Object {
    @objc dynamic var detail = ""
    @objc dynamic var status = 0
    @objc dynamic var owner:Assignee!
}
