//
//  Post.swift
//  Waste Manager
//
//  Created by 최유현 on 11/20/23.
//

import Foundation
import UIKit

struct Post: Codable {
    var userID: String
    var imageUI: String
    var date: String
    var text: String
    var likedUserIDs: Set<String> // 좋아요를 누른 사용자의 식별자 리스트
    var category: String
    var document: String
}

class Posts {
    static var posts: [Post] = []
}

