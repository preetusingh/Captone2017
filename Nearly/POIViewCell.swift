//
//  POIViewCell.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/27/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit
import AFNetworking

class POIViewCell: UITableViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    var location : POI!{
        didSet{
            placeNameLabel.text = location.placeName
            
            placeImageView.image = nil
            
            if location.placeImageURL != nil{
                //print("Final url us \(location.placeImageURL!)")
                placeImageView.setImageWith(location.placeImageURL!)
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

