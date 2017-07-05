//
//  ProductsViewController.swift
//  Junto_Test
//
//  Created by Sergey on 7/4/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit
import MKDropdownMenu
import Foundation


class ProductsViewController: UIViewController, MKDropdownMenuDataSource, MKDropdownMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var categories = [Category]()
    private var products = [Product]()
    private var currentCategory : Category?

    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        indicator.layer.zPosition = 10
        return indicator
    }()
    
    lazy var refreshControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProductsViewController.refreshProducts(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let barMenu = MKDropdownMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setTranslucentNavigationBar()
        setDropdownMenu()
        fetchCategories()
    }
    
    
    private func setTableView(){
        activityIndicator.frame = view.bounds
        tableView.addSubview(refreshControl!)
        view.backgroundColor = UIColor.orange
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func refreshProducts(_ refreshControl : UIRefreshControl){
        fetchProductsFromCategory(category: currentCategory, enableActivityIndicator: false, refreshControl: refreshControl)
    }
    
    private func setDropdownMenu(){
        barMenu.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: navigationController!.navigationBar.frame.height)
        
        barMenu.dataSource = self
        barMenu.delegate = self
        barMenu.tintColor = UIColor.white
        barMenu.rowSeparatorColor = UIColor.orange
        navigationItem.titleView = barMenu
        barMenu.useFullScreenWidth = true
    }
    
    private func setTranslucentNavigationBar(){
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell", for: indexPath) as! ProductTableViewCell
        
        cell.productNameLabel.text = products[indexPath.row].title
        cell.thumbnailImageView.image = products[indexPath.row].image
        cell.productDescriptionLabel.text = products[indexPath.row].description
        
        
        if let cachedImage = imageCache.cache.object(forKey: products[indexPath.row].imageUrl as AnyObject) as! UIImage?{
            cell.thumbnailImageView.image = cachedImage
        }
        
        
        //URL session for fetching actual image
        
        URLSession.shared.dataTask(with: URL(string : products[indexPath.row].imageUrl)!) { (data, response, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            if let image = UIImage(data: data!){
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? ProductTableViewCell{
                        cell.thumbnailImageView.image = image
                        if self.products.count > indexPath.row{
                            self.products[indexPath.row].image = image
                        }
                    }
                }
            }
        }.resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if refreshControl != nil && refreshControl!.isRefreshing{
            refreshControl!.endRefreshing()
        }
        performSegue(withIdentifier: "Show Product Info", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Product Info"{
            let indexPath = sender as! IndexPath
            let destinationVC = segue.destination as! ProductInfoViewController
            destinationVC.product = products[indexPath.row]
        }
    }
    

    
    
    func fetchCategories(){
        self.tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        //Url config
        var url = URL(string: "https://api.producthunt.com/v1/categories")!
        let URLParams = [
            "access_token": "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff",
            ]
        
        url = url.appendingQueryParameters(URLParams)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let bodyObject: [String : Any] = [:]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        
        
        request.addValue("__cfduid=(null)", forHTTPHeaderField: "Cookie")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            do{
                let _json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let json = _json["categories"]{
                    
                    for dictionary in json as! [[String : AnyObject]]{
                        self.categories.append(Category(
                            id: dictionary["id"] as? String ?? "0",
                            slug: dictionary["slug"] as? String ?? "",
                            name: dictionary["name"] as? String ?? "")
                        )
                    }
                }
                
                DispatchQueue.main.async {
                    self.currentCategory = self.categories[0]
                    self.barMenu.reloadAllComponents()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    self.fetchProductsFromCategory(category: self.currentCategory!, enableActivityIndicator: true, refreshControl: nil)
                }
                
                
            } catch{
                print("Error parsing data")
            }
        }
        
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func fetchProductsFromCategory(category : Category?, enableActivityIndicator : Bool, refreshControl: UIRefreshControl?){
        guard category != nil else {
            return
        }
        
        if refreshControl != nil{
            refreshControl!.beginRefreshing()
        }
        //start activity indicator
        
        if enableActivityIndicator == true{
            self.tableView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        //Url config
        var url = URL(string: "https://api.producthunt.com/v1/posts/all")!
        let URLParams = [
            "access_token": "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff",
            "search[category]" : category!.slug
            ]
        
        url = url.appendingQueryParameters(URLParams)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let bodyObject: [String : Any] = [:]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        
        //Headers from paw
        
        request.addValue("__cfduid=(null)", forHTTPHeaderField: "Cookie")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let _json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let json = _json["posts"]{
                        
                        self.products.removeAll()
                        for dictionary in json as! [[String : AnyObject]]{
                            var thumbnailUrl : String?
                            if let imageUrlPath = dictionary["thumbnail"] as? [String : AnyObject]{
                                thumbnailUrl = imageUrlPath["image_url"] as? String
                            }
                            
                            self.products.append(Product(
                                title: dictionary["name"] as! String,
                                description: dictionary["tagline"] as! String,
                                imageUrl: thumbnailUrl!,
                                upvotes: String(dictionary["votes_count"] as! Int),
                                redirectUrl: dictionary["redirect_url"] as! String)
                            )
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if enableActivityIndicator == true{
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.removeFromSuperview()
                        }
                        if refreshControl != nil{
                            refreshControl!.endRefreshing()
                        }
                    }
                } catch{
                    print("Error parsing data")
                }
        }
        
    }
    
        task.resume()
        session.finishTasksAndInvalidate()
    }


        //DropDown Menu datasource

    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        print(categories.count)
        return categories.count
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
        if categories.count > 0 && categories.count > row{
            return categories[row].name
        } else {
            return ""
        }
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForComponent component: Int) -> String? {
        if categories.count > 0{
            return currentCategory!.name

        } else {
            return "Tech"
        }
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        if refreshControl != nil && refreshControl!.isRefreshing{
            refreshControl!.endRefreshing()
        }
        
        products.removeAll()
        currentCategory = categories[row]
        fetchProductsFromCategory(category: currentCategory, enableActivityIndicator: true, refreshControl: nil)
        dropdownMenu.reloadAllComponents()
        dropdownMenu.closeAllComponents(animated: true)
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, backgroundColorForHighlightedRowsInComponent component: Int) -> UIColor? {
        return UIColor.orange
    }
    

}
