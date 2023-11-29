//
//  CommunityViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CommunityViewController: UIViewController {
    
    let communityView = CommunityView()
    let db = Firestore.firestore()
    
    var posts = Posts.posts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communityView.communities.dataSource = self
        communityView.communities.delegate = self
        
        view.addSubview(communityView)
        
        NSLayoutConstraint.activate([
            communityView.topAnchor.constraint(equalTo: view.topAnchor),
            communityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            communityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            communityView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let addButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.image = UIImage(systemName: "plus.app")
        
        let reloadButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reloadButtonTapped))
        reloadButton.image = UIImage(systemName: "arrow.clockwise")
        
        self.navigationItem.rightBarButtonItems = [addButton]
        self.navigationItem.leftBarButtonItem = reloadButton
        
        loadPosts()
    }
    
    @objc func addButtonTapped() {
        if Auth.auth().currentUser != nil {
            self.navigationController?.pushViewController(NewPostViewController(), animated: true)
        } else {
            showLoginFirstAlert(error: "Please Login First")
        }
    }
    
    @objc func reloadButtonTapped() {
        loadPosts()
    }
    
    private func showLoginFirstAlert(error: String) {
        let alert = UIAlertController(title: "Login First", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadPosts() {
        posts = []
        
        db.collection(K.collection).order(by: K.date, descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let imageURL = data[K.imageUI] as? String, let date = data[K.date] as? String, let text = data[K.text] as? String, let user = data[K.userID] as? String, let category = data[K.category] as? String, let likes = data[K.likedUserIDs] as? [String]{
                        
                        let likesSet = Set(likes)
                        
                        let newPost = Post(userID: user, imageUI: imageURL, date: date, text: text, likedUserIDs: likesSet, category: category, document: document.documentID)
                        self.posts.append(newPost)
                        
                        DispatchQueue.main.async {
                            self.communityView.communities.reloadData()
                        }
                    } else {
                        print("error")
                    }
                }
            }
        }
    }
}

//MARK: - TableView Extension

extension CommunityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = communityView.communities.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier, for: indexPath) as! CommunityTableViewCell
        
        let image = posts[indexPath.row].imageUI
        let date = posts[indexPath.row].date
        let text = posts[indexPath.row].text
        
        cell.postDate.text = date
        cell.postDetail.text = text
        
        if let imageUrl = URL(string: image) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.postImage.image = image
                    }
                }
            }.resume()
        }
        
        cell.postLikes.isHidden = true
        
        return cell
    }
}

extension CommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetail = PostDetailViewController()
        postDetail.post = posts[indexPath.row]
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
}
