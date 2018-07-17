//
//  TodoCelllTableViewCell.swift
//  Todo_list
//
//  Created by Reel on 14/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit
import M13Checkbox
class TodoCell: UITableViewCell {
    var type = 0
    var todoName = ""

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var todoText: UILabel!
    
    

}
