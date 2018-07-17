//
//  ProjTableViewCell.swift
//  Todo_list
//
//  Created by Reel on 15/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit

class ProjTableViewCell: UITableViewCell {

   
    @IBOutlet weak var doneIm: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
