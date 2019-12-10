//
//  Product.swift
//  Artable
//
//  Created by Trần Thành on 12/5/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import Foundation
import FirebaseFirestore
struct Product {
    var name : String
    var id : String
    var category : String
    var price : Double
    var productDescription : String
    var imageUrl :String
    var stock : Int
    var timeStamp : Timestamp
    
    
    init(
        name : String ,
        id : String ,
        category : String ,
        price : Double ,
        productDescription : String ,
        imageUrl : String ,
        stock : Int = 0,
        timeStamp : Timestamp = Timestamp()) {
          self.name = name
          self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imageUrl
        self.stock = stock
        self.timeStamp = timeStamp
    }
    
    
    
    init(data : [String : Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.stock = data["stock"] as? Int ?? 0
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    
    static func modelToData(product : Product) -> [String : Any] {
        let data : [String : Any] = [
            "name"  : product.name,
            "id"  : product.id,
            "category" : product.category,
            "price"  : product.price,
            "productDescription" : product.productDescription,
            "imageUrl"  : product.imageUrl,
            "stock " : product.stock,
            "timeStamp"  : product.timeStamp
        ]
        return data
    }
}
