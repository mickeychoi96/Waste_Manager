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
    let db = Database.shared
    let postManager = PostManager.shared

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
        
        uiSetting()
        reloadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableView()
    }
    
    private func uiSetting() {
        let addButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.image = UIImage(systemName: "plus.app")
        
        let reloadButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reloadButtonTapped))
        reloadButton.image = UIImage(systemName: "arrow.clockwise")
        
        self.navigationItem.rightBarButtonItems = [addButton]
        self.navigationItem.leftBarButtonItem = reloadButton
    }
    
    @objc private func addButtonTapped() {
        if Auth.auth().currentUser != nil {
            self.navigationController?.pushViewController(NewPostViewController(), animated: true)
        } else {
            showLoginFirstAlert(error: "Please Login First")
        }
    }
    
    @objc private func reloadButtonTapped() {
        self.reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.communityView.communities.reloadData()
        }
    }
    
    private func showLoginFirstAlert(error: String) {
        let alert = UIAlertController(title: "Login First", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - TableView Extension

extension CommunityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postManager.getAllPosts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = communityView.communities.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier, for: indexPath) as! CommunityTableViewCell
        let post = postManager.getPost(indexPath.row)
        let image = post.imageUI
        let date = post.date
        let text = post.text
        
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
        let post = postManager.getPost(indexPath.row)
        postDetail.post = post
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
}
