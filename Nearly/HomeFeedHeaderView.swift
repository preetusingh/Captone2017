//
//  HomeFeedHeaderView.swift
//  Nearly
//
//  Created by Dhara's Mac on 7/9/17.
//  Copyright © 2017 Nearly. All rights reserved.
//

import UIKit

class HomeFeedHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var customContentView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "HomeFeedHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        customContentView.frame = bounds
        contentView.addSubview(customContentView)
    }


}
