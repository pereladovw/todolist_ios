//
//  Project.swift
//  Todo_list
//
//  Created by Reel on 16/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit
import Foundation


class Project: NSObject, Decodable  {
    var id : Int
    var title : String
    
    init(title : String, id: Int) {
        self.title = title
        self.id = id
    }
  
}


