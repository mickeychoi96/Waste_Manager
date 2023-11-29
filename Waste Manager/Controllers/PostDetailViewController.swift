//
//  PostDetailViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/22/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostDetailViewController: UIViewController {
    
    let postDetailView = PostDetailView()
    
    let db = Firestore.firestore()
    
    public var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let post = post {
            if let imageUrl = URL(string: post.imageUI) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.postDetailView.postImage.image = image
                        }
                    }
                }.resume()
            }
            
            postDetailView.postDate.text = post.date
            postDetailView.postDetail.text = post.text
            postDetailView.likeCount.text = String(post.likedUserIDs.count)
        }
        
        view.addSubview(postDetailView)
        
        NSLayoutConstraint.activate([
            postDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            postDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let post = post {
            if Auth.auth().currentUser?.email == post.userID {
                let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
                self.navigationItem.rightBarButtonItem = deleteButton
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        if let post = post {
            db.collection(K.collection).document(post.document).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
}
