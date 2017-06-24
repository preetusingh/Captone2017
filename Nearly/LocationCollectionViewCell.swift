//
//  LocationCollectionViewCell.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/27/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit
import AFNetworking
let placeholderImage = UIImage(named: "NoImagePlaceHolder")
class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescription : UILabel!
    
    var location : POI!{
        didSet{
            placeNameLabel.text = location.placeName
            
            placeImageView.image = nil
            
            if location.placeImageURL != nil{
                
                placeImageView.setImageWith(location.placeImageURL!, placeholderImage: placeholderImage)
                
            }
            placeDescription.text = location.placeDescription
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        placeImageView.layer.shadowColor = UIColor.lightGray.cgColor
        placeImageView.layer.shadowOpacity = 1
        placeImageView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        placeImageView.layer.shadowRadius = 20
        
        
    }
    func startSelectedAnimation(completion:@escaping (LocationCollectionViewCell)->()) {
        self.placeNameLabel.textColor = UIColor.black
        weak var weakSelf = self
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                                                        weakSelf?.placeNameLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                                                        
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                        weakSelf?.placeNameLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                                    
        },
                                completion: { (didComplete:Bool) in
                                    if let strongSelf = weakSelf {
                                        strongSelf.placeNameLabel.textColor = UIColor.white
                                        
                                        print("Run COMPLETION")
                                        completion(strongSelf)
                                    }
        })
        
        
    }
    
}

