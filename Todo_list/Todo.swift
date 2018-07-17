//
//  Todo.swift
//  Todo_list
//
//  Created by Reel on 16/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit

class Todo: NSObject, Decodable, Encodable {
    var id : Int
    var project_id : Int
    var text = ""
    var isCompleted : Bool = false
    
    init(text: String, id: Int, project_id: Int) {
        self.id = id
        self.project_id = project_id
        self.text = text
    }
    
    init(text: String, id: Int, project_id: Int, isCompleted: Bool) {
        self.id = id
        self.project_id = project_id
        self.text = text
        self.isCompleted = isCompleted
    }
    
}
