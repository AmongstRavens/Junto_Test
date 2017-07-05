//
//  ProductTableViewCell.swift
//  Junto_Test
//
//  Created by Sergey on 7/4/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var upvotesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 4
        thumbnailImageView.clipsToBounds = true
        
        upvotesLabel.layer.borderWidth = 1
        upvotesLabel.layer.borderColor = UIColor.lightGray.cgColor
        upvotesLabel.layer.cornerRadius = 4
        upvotesLabel.clipsToBounds = true
    }

}
