//
//  Database.swift
//  Waste Manager
//
//  Created by 최유현 on 11/30/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class Database {
    
    static let shared = Database()

    private init() {}
    
    let db = Firestore.firestore()
    
    let postManager = PostManager.shared
    
    let userEmail = Auth.auth().currentUser?.email
    
    func loadFullData(completion: @escaping () -> Void) {
        postManager.deleteAllPosts()
        
        db.collection(K.collection).order(by: K.date, descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let imageURL = data[K.imageUI] as? String, let date = data[K.date] as? String, let text = data[K.text] as? String, let user = data[K.userID] as? String, let category = data[K.category] as? String, let likes = data[K.likedUserIDs] as? [String]{
                        
                        let likesSet = Set(likes)
                        
                        let newPost = Post(userID: user, imageUI: imageURL, date: date, text: text, likedUserIDs: likesSet, category: category, document: document.documentID)
                        
                        self.postManager.addPost(newPost)
                    } else {
                        print("error")
                    }
                }
                
                completion()
            }
        }
    }
    
    func addPost(_ post: Post) {
        do {
            try self.db.collection("post").document().setData(from: post)
            
        } catch let error {
            print("Error writing post to Firestore: \(error)")
        }
    }
    
    func deletePost(_ post: Post) {
        db.collection(K.collection).document(post.document).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func updateLike(_ id: String, _ check: Bool, completion: @escaping () -> Void) {
        if !check {
            db.collection(K.collection).document(id).updateData([
                K.likedUserIDs: FieldValue.arrayUnion([userEmail ?? ""])
            ]) { error in
                if let e = error {
                    print(e)
                } else {
                    completion()
                }
            }
        } else {
            db.collection(K.collection).document(id).updateData([
                K.likedUserIDs: FieldValue.arrayRemove([userEmail ?? ""])
            ]) { error in
                if let e = error {
                    print(e)
                } else {
                    completion()
                }
            }
        }
    }
}

