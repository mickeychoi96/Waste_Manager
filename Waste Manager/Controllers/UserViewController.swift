//
//  UserViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/15/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserViewController: UIViewController {

    
    let userView = UserView()
    
    let db = Firestore.firestore()

    var imageSample = UIImage(named: "Sample")
    
    let tableSample: [(String, Float)] = [("Item 1", 0.3), ("Item 2", 0.7), ("Item 3", 0.5)]
    
    var posts = Posts.posts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userView.progressesView.dataSource = self
        userView.progressesView.delegate = self
        
        userView.myPostView.dataSource = self
        userView.myPostView.delegate = self
        
        view.addSubview(userView)
        
        userView.emailLabel.text = Auth.auth().currentUser?.email
        
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.topAnchor),
            userView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadPostsUserOnly()
    }
    
    func loadPostsUserOnly() {
        posts = []
        
        db.collection(K.collection).order(by: K.date, descending: true).whereField(K.userID, isEqualTo: Auth.auth().currentUser!.email!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let imageURL = data[K.imageUI] as? String, let date = data[K.date] as? String, let text = data[K.text] as? String, let user = data[K.userID] as? String, let category = data[K.category] as? String, let likes = data[K.likedUserIDs] as? [String] {
                        
                        let likesSet = Set(likes)
                        let newPost = Post(userID: user, imageUI: imageURL, date: date, text: text, likedUserIDs: likesSet, category: category, document: document.documentID)
                        self.posts.append(newPost)
                        
                        DispatchQueue.main.async {
                            self.userView.myPostView.reloadData()
                        }
                    } else {
                        print("error")
                    }
                }
            }
        }
    }
}

//MARK: - TableView Delegate

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userView.progressesView.dequeueReusableCell(withIdentifier: ProgressTableViewCell.identifier, for: indexPath) as! ProgressTableViewCell
        let (iconLabel, progress) = tableSample[indexPath.row]
        
        cell.iconLabel.text = iconLabel
        cell.progressBar.progress = progress
        
        return cell
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected: \(tableSample[indexPath.row].0)")
    }
}

//MARK: - Collection View

extension UserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userView.myPostView.dequeueReusableCell(withReuseIdentifier: MyPostCollectionViewCell.identifier, for: indexPath) as! MyPostCollectionViewCell
        
        let image = posts[indexPath.row].imageUI
        
        if let imageUrl = URL(string: image) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
}

extension UserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postDetail = PostDetailViewController()
        postDetail.post = posts[indexPath.row]
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
}

