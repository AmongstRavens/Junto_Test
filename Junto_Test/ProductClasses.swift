//
//  ProductClasses.swift
//  Junto_Test
//
//  Created by Sergey on 7/5/17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit
import Foundation

class Category{
    let id : String
    let slug : String
    let name : String
    
    init(id: String, slug: String, name: String){
        self.id = id
        self.slug = slug
        self.name = name
    }
}

class Product{
    var imageUrl : String
    var image : UIImage?
    var title : String
    var description : String
    var upvotes : String
    var redirectUrl : String
    
    init(title: String, description : String, imageUrl: String, upvotes: String, redirectUrl : String){
        self.description = description
        self.title = title
        self.imageUrl = imageUrl
        self.upvotes = upvotes
        self.redirectUrl = redirectUrl
    }
}

struct imageCache{
    static var cache = NSCache<AnyObject, AnyObject>()
}


