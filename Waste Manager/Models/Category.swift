//
//  Categories.swift
//  Waste Manager
//
//  Created by 최유현 on 11/22/23.
//

import Foundation
import UIKit

struct Category: Codable {
    let name: String
}

class Categories {
    static let categories: [Category] = [
        Category(name: "Default"),
        Category(name: "Can"),
        Category(name: "Plastic bottle"),
        Category(name: "Paper"),
    ]
    
    static let categoriesUsed: [(Category, Float)] = [
        (Category(name: "Default"), 0),
        (Category(name: "Can"), 0),
        (Category(name: "Plastic bottle"), 0),
        (Category(name: "Paper"), 0)
    ]
    
    static var total: Float = 0
}
