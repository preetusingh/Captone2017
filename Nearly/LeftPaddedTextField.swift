//
//  LeftPaddedTextField.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/27/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit

class LeftPaddedTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width-50, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }

}
