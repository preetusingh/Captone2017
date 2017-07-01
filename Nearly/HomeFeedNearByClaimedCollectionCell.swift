//
//  HomeFeedNearByClaimedCollectionCell.swift
//  Nearly
//
//  Created by Dhara's Mac on 7/1/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit

class HomeFeedNearByClaimedCollectionCell: NearByClaimedCollectionCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }

}
