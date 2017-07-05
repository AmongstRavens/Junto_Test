//
//  WebViewController.swift
//  Junto_Test
//
//  Created by Sergey on 7/5/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var product : Product?
    
    private var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpActivityIndicator()
        webView.delegate = self
        view.backgroundColor = .orange
        navigationItem.title = product?.title
        webView.loadRequest(URLRequest(url: URL(string: product!.redirectUrl)!))
    }
    
    func setUpActivityIndicator(){
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.layer.zPosition = 5
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
