//
//  ProductInfoViewController.swift
//  Junto_Test
//
//  Created by Sergey on 7/5/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var gotItButton: UIButton!
    
    private var barImageView : HeaderView?
    
    struct HeaderConstants {
        static let height : CGFloat = 120
    }
    
    private var barText : UILabel?
    private var barVeil : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        settupBarImage()
        productDescriptionLabel.text = "Produc description goes here"
    }
    
    @IBAction func gotIt(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Web View", sender: self)
    }
    
    func settupBarImage(){
        let barViewFrame = CGRect(x: 0, y: -HeaderConstants.height, width: scrollView.frame.width, height: HeaderConstants.height)
        barImageView = HeaderView(title: "Title here", upVotes: 999, frame: barViewFrame, image: #imageLiteral(resourceName: "iamge"))
        
        scrollView.contentInset = UIEdgeInsetsMake(HeaderConstants.height, 0, 0, 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -HeaderConstants.height)
        scrollView.addSubview(barImageView!)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < barImageView!.frame.height{
            barImageView!.frame.origin.y = scrollView.contentOffset.y
            barImageView!.frame.size.height = -scrollView.contentOffset.y
            barImageView!.setNeedsLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let barView = barImageView{
            barView.frame.size.width = size.width
            barView.frame.size.height = HeaderConstants.height
            barView.setNeedsLayout()
        }
    }

}
