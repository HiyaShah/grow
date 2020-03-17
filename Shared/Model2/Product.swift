//
//  Product.swift
//  Grow
//
//  Created by Hiya Shah on 2/16/20.
//  Copyright © 2020 Hiya Shah. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timeStamp: Timestamp
    var stock: Int
    
    init (
        name: String,
        price: Double,
        id: String,
        productDescription: String,
        category: String,
        stock: Int = 0,
        imageUrl: String,
        timeStamp: Timestamp = Timestamp()) {
        self.name = name
        self.id = id
        self.price = price
        self.productDescription = productDescription
        self.category = category
        self.stock = stock
        self.imageUrl = imageUrl
        self.timeStamp = timeStamp
    }
    
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.stock = data["stock"] as? Int ?? 0
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(product: Product) -> [String: Any] {
        let data : [String: Any] = [
            "name" : product.name,
            "id": product.id,
            "imageUrl": product.imageUrl,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDescription,
            "stock": product.stock,
            "timeStamp": product.timeStamp
            
        ]
        return data
    }
}


extension Product : Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
