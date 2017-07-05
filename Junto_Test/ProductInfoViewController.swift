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
    var product : Product!
    
    struct HeaderConstants {
        static let height : CGFloat = 120
    }
    
    private var barText : UILabel?
    private var barVeil : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        settupBarImage()
        productDescriptionLabel.text = product?.description
    }
    
    @IBAction func gotIt(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Web View", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Web View"{
            let destinationVC = segue.destination as! WebViewController
            destinationVC.product = product
            navigationItem.title = ""
        }
    }
    
    func settupBarImage(){
        let barViewFrame = CGRect(x: 0, y: -HeaderConstants.height, width: scrollView.frame.width, height: HeaderConstants.height)
        
        //fetch image if it's still nil
        if product?.image == nil{
            barImageView = HeaderView(title: product!.title, upVotes: product!.upvotes, frame: barViewFrame, image: nil)
            URLSession.shared.dataTask(with: URL(string : product!.imageUrl)!) { (data, response, error) in
                guard error == nil else{
                    print(error!.localizedDescription)
                    return
                }
                
                if let image = UIImage(data: data!){
                    DispatchQueue.main.async {
                        self.barImageView?.image = image
                    }
                }
                }.resume()
            

        } else{
            barImageView = HeaderView(title: product!.title, upVotes: product!.upvotes, frame: barViewFrame, image: product!.image!)
        }
        scrollView.contentInset = UIEdgeInsetsMake(HeaderConstants.height, 0, 0, 0)
        scrollView.contentOffset = CGPoint(x: 0, y: -HeaderConstants.height)
        scrollView.addSubview(barImageView!)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < barImageView!.frame.height{
            barImageView?.frame.origin.y = scrollView.contentOffset.y
            barImageView?.frame.size.height = -scrollView.contentOffset.y
            barImageView?.setNeedsLayout()
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
