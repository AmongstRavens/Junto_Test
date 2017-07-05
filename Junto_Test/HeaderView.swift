//
//  HeaderView.swift
//  Junto_Test
//
//  Created by Sergey on 7/5/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class HeaderView: UIImageView {
    private var veilView = UIView()
    private var textLabel = UILabel()
    private var upvotesLabel = UILabel()
    
    convenience init (title : String, upVotes : Int, frame : CGRect, image : UIImage){
        self.init(frame: frame)
        self.image = image
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        textLabel.frame.size.width = frame.width * 2/3
        
        textLabel.text = title
        textLabel.sizeToFit()
        textLabel.font = UIFont(name: "system", size: 20)
        textLabel.textColor = UIColor.white
        textLabel.frame.origin = CGPoint(x: 20, y: frame.height - textLabel.frame.height - 20)
        
        veilView.frame = frame
        veilView.frame.origin.y = 0
        veilView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        
        self.addSubview(veilView)
        self.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        veilView.frame = self.frame
        veilView.frame.origin.y = 0
        textLabel.frame.origin = CGPoint(x: 20, y: frame.height - textLabel.frame.height - 20)
    }

}
