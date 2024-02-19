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
    var usage: Float
}

class CategoryManager {
    static let shared = CategoryManager()

    private let categoriesKey = "categoriesKey"
    private var categories: [Category] = []

    init() {
        loadCategories()
    }

    func getCategoriesUsed() -> [Category] {
        return categories
    }

    func updateCategoryUsage(name: String, usage: Float) {
        if let index = categories.firstIndex(where: { $0.name == name }) {
            categories[index].usage = usage
        }
        saveCategories()
    }

    private func saveCategories() {
        if let encodedData = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encodedData, forKey: categoriesKey)
        }
    }

    private func loadCategories() {
        if let savedData = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedData = try? JSONDecoder().decode([Category].self, from: savedData) {
            categories = decodedData
        } else {
            // 초기 카테고리 설정
            categories = [
                Category(name: "Can", usage: 0),
                Category(name: "Plastic bottle", usage: 0),
                Category(name: "Paper", usage: 0),
                Category(name: "Clothes", usage: 0),
                Category(name: "Toothbrush", usage: 0),
                Category(name: "Glass bottle", usage: 0),
                Category(name: "Towel", usage: 0)
            ]
        }
    }
    
    func increaseCategory(name: String) {
        if let index = categories.firstIndex(where: { $0.name == name }) {
            categories[index].usage += 1 // 현재 값에 1을 증가
            print("It is working",categories)
            saveCategories() // 변경된 데이터 저장
        }
    }
    
    func getTotalUsage() -> Float {
        var total: Float = 0
        for usage in categories {
            total += usage.usage
        }
        return total
    }
}



