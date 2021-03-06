//
//  TextField.swift
//  Todo_list
//
//  Created by Reel on 15/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
    }
    

}
