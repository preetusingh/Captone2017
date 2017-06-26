//
//  NearByClaimedCollectionCell.swift
//  Nearly
//
//  Created by Dhara's Mac on 6/24/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"





class NearByClaimedCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet var customContentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var claimedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "NearByClaimedCollectionCell", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        customContentView.frame = self.contentView.bounds
        contentView.addSubview(customContentView)
    }
    
    func startSelectedAnimation(completion:@escaping (NearByClaimedCollectionCell)->()) {
        weak var weakSelf = self
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                                                        
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                                    
        },
                                completion: { (didComplete:Bool) in
                                    if let strongSelf = weakSelf {
                                        completion(strongSelf)
                                    }
        })
        
        
    }
    
}

