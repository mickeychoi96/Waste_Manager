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

class PostManager {
    
    static let shared = PostManager()

    private init() {}
    
    private var posts: [Post] = []
    
    func getAllPosts() -> [Post] {
        return posts
    }
    
    func deleteAllPosts() {
        posts.removeAll()
    }

    func addPost(_ post: Post) {
        posts.append(post)
    }
    
    func emptyCheck() -> Bool {
        return posts.isEmpty
    }
    
    func getPost(_ num: Int) -> Post {
        return posts[num]
    }
    
    func getPostsByCategory(_ category: String) -> [Post] {
        return posts.filter { $0.category == category }
    }
    
    func deletePost(_ post: Post) {
        let id = post.document
        if let index = posts.firstIndex(where: { $0.document == id }) {
            posts.remove(at: index)
        }
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
    
    func getUserPosts(userId: String) -> [Post] {
        return posts.filter { $0.userID == userId }
    }
    
    func likePost(_ num: Int, _ userEmail: String) {
        posts[num].likedUserIDs.insert(userEmail)
    }
    
    func dislikePost(_ num: Int, _ userEmail: String) {
        posts[num].likedUserIDs.remove(userEmail)
    }
    
    func updatePost(_ updatedPost: Post) {
        if let index = posts.firstIndex(where: { $0.document == updatedPost.document }) {
            posts[index] = updatedPost
        }
    }
}

