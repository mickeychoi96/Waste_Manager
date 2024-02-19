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
    
    let postManager = PostManager.shared
    
    let categoryManager = CategoryManager.shared
    
    var imageSample = UIImage(named: "Sample")
    
    let tableSample: [(String, Float)] = [("Item 1", 0.3), ("Item 2", 0.7), ("Item 3", 0.5)]
    
    let userEmail = Auth.auth().currentUser?.email
    
    var userPosts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userView.progressesView.dataSource = self
        userView.progressesView.delegate = self
        
        userView.myPostView.dataSource = self
        userView.myPostView.delegate = self
        
        view.addSubview(userView)
        
        userView.emailLabel.text = userEmail ?? ""
        
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: view.topAnchor),
            userView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        userPosts = postManager.getUserPosts(userId: userEmail ?? "")
        
        DispatchQueue.main.async {
            self.userView.progressesView.reloadData()
        }
    }
}

//MARK: - TableView Delegate

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryManager.getCategoriesUsed().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userView.progressesView.dequeueReusableCell(withIdentifier: ProgressTableViewCell.identifier, for: indexPath) as! ProgressTableViewCell
        let category = categoryManager.getCategoriesUsed()[indexPath.row]

        let totalUsage = categoryManager.getTotalUsage()
        cell.iconLabel.text = category.name
        cell.progressBar.progress = category.usage/totalUsage
        
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
        return userPosts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userView.myPostView.dequeueReusableCell(withReuseIdentifier: MyPostCollectionViewCell.identifier, for: indexPath) as! MyPostCollectionViewCell
        
        let image = userPosts?[indexPath.row].imageUI
        
        if let imageUrl = URL(string: image ?? "") {
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
        postDetail.post = userPosts?[indexPath.row]
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
}

