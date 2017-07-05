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
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .white
        indicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
        indicator.layer.zPosition = 10
        return indicator
    }()
    
    convenience init (title : String, upVotes : String, frame : CGRect, image : UIImage?){
        self.init(frame: frame)
        if image != nil{
            self.image = image
        }
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        textLabel.font = UIFont(name: "SanFranciscoText-Medium", size: 22)
        textLabel.textColor = UIColor.white
        textLabel.numberOfLines = 2
        
        veilView.frame = frame
        veilView.frame.origin.y = 0
        veilView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        
        let constraintRect = CGSize(width: frame.width * 2/3, height: .greatestFiniteMagnitude)
        let boundingBox = title.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textLabel.font], context: nil)
        
        textLabel.frame.size.width = frame.width * 2/3
        textLabel.frame.size.height = boundingBox.height
        textLabel.text = title
        textLabel.frame.origin = CGPoint(x: 20, y: frame.height - textLabel.frame.height - 10)
        
        
        self.addSubview(veilView)
        self.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        veilView.frame = self.bounds
        activityIndicator.frame = self.bounds
        
        
        let constraintRect = CGSize(width: frame.width * 2/3, height: .greatestFiniteMagnitude)
        let boundingBox = textLabel.text!.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textLabel.font], context: nil)
        
        textLabel.frame.size.width = frame.width * 2/3
        textLabel.frame.size.height = boundingBox.height
        textLabel.frame.origin = CGPoint(x: 20, y: frame.height - textLabel.frame.height - 10)
    }
    
    func enableActivityIndicator(){
        activityIndicator.frame = self.bounds
        activityIndicator.frame.origin = CGPoint(x: 0, y: 0)
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func disableActivityIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

}
