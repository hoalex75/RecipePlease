//
//  RatingView.swift
//  RecipePlease
//
//  Created by Alex on 25/05/2019.
//  Copyright © 2019 Alexandre Holet. All rights reserved.
//

import UIKit

class RatingView: UIView {
    
    @IBOutlet weak var bottomImageView: UIImageView!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)
        contentView.fixInView(self)
        contentView.layer.borderWidth = 2.0
        let blue = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        contentView.layer.borderColor = blue.cgColor
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
