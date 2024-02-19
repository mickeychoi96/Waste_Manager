//
//  PostDetailViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/22/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostDetailViewController: UIViewController {
    
    let postDetailView = PostDetailView()
    
    let postManager = PostManager.shared
    
    let db = Database.shared
    
    let storageRef = Storage.storage().reference()
    
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
        
        postDetailView.likeButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        updateLikeUI(userEmail: Auth.auth().currentUser?.email ?? "")
    }
    
    @objc func heartButtonPressed() {
        if let userEmail = Auth.auth().currentUser?.email{
            let documentID = self.post!.document
            let isLiked = self.post!.likedUserIDs.contains(userEmail)
            
            db.updateLike(documentID, isLiked) {
                DispatchQueue.main.async {
                    if !isLiked {
                        self.post!.likedUserIDs.insert(userEmail)
                    } else {
                        self.post!.likedUserIDs.remove(userEmail)
                    }
                    self.postManager.updatePost(self.post!)
                    self.updateLikeUI(userEmail: userEmail)
                }
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        presentDeleteAlert()
    }
    
    private func presentDeleteAlert() {
        let alert = UIAlertController(title: "Delete Post", message: "Do you want to delete the post?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.deletePost()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func deletePost() {
        if let post = post {
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: post.imageUI)
            
            storageRef.delete { error in
                if let error = error {
                    print(error)
                } else {
                    print("Image successfully removed!")
                }
            }
            
            db.deletePost(post)
            postManager.deletePost(post)
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateLikeUI(userEmail: String) {
        if let post = post{
            postDetailView.likeCount.text = String(post.likedUserIDs.count)
            if post.likedUserIDs.contains(userEmail) {
                postDetailView.likeButton.tintColor = .red
            } else {
                postDetailView.likeButton.tintColor = .gray
            }
        }
    }
}
