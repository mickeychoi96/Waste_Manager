//
//  HomeViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeViewController: UIViewController, UINavigationControllerDelegate {
        
    let homeView = HomeView()
    
    let db = Database.shared
    
    let postManager = PostManager.shared
    
    let categories = CategoryManager.shared
    
    let community = CommunityViewController()
    
    var randomInt = 0
        
    let imagePicker = UIImagePickerController()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        db.getRandomData {
            DispatchQueue.main.async {
                self.updateHomeView()
            }
        }
        
        // 나머지 UI 설정
        setupNavigationBar()
        setupHomeViewLayout()
        
        homeView.likeButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        homeView.cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        
        DispatchQueue.main.async {
            self.homeView.progressesTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadButtonTapped), name: NSNotification.Name("HomeDataRefreshNotification"), object: nil)
    }

    func updateHomeView() {
        if  !postManager.recommendPostEmptyCheck() {
            let post = postManager.getRecommendPost()

            if let email = Auth.auth().currentUser?.email {
                self.updateLikeUI(userEmail: email)
            }
            
            homeView.postDetailLabel.text = post.text
            homeView.postDateLabel.text = post.date

            if let imageUrl = URL(string: post.imageUI) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.homeView.postImageView.image = image
                        }
                    }
                }.resume()
            }
        }
    }

    func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(rightButtonItemPressed))
        barButtonItem.image = UIImage(systemName: "person.fill")
        
        
        let reloadButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(reloadButtonTapped))
        reloadButton.image = UIImage(systemName: "arrow.clockwise")
        
        self.navigationItem.rightBarButtonItems = [barButtonItem]
        self.navigationItem.leftBarButtonItem = reloadButton
    }

    func setupHomeViewLayout() {
        view.addSubview(homeView)
        homeView.progressesTableView.dataSource = self

        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let postTapped = UITapGestureRecognizer(target: self, action: #selector(recommendPostTapped))
        homeView.recommendPostStackView.addGestureRecognizer(postTapped)
    }

    //MARK: - Button Action
    
    @objc func rightButtonItemPressed() {
        if Auth.auth().currentUser != nil {
            self.navigationController?.pushViewController(UserViewController(), animated: true)
        } else {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
    
    @objc func reloadButtonTapped() {
        postManager.deleteRecommendPost()
        db.getRandomData {
            DispatchQueue.main.async {
                self.updateHomeView()
            }
        }
    }
    
    @objc func recommendPostTapped() {
        let postDetail = PostDetailViewController()
        postDetail.post = postManager.getRecommendPost()
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
    
    @objc func heartButtonPressed() {
        if let userEmail = Auth.auth().currentUser?.email {
            let documentID = postManager.getRecommendPost().document
            let isLiked = postManager.getRecommendPost().likedUserIDs.contains(userEmail)

            if !isLiked {
                db.db.collection(K.collection).document(documentID).updateData([
                    K.likedUserIDs: FieldValue.arrayUnion([userEmail])
                ]) { error in
                    if let e = error {
                        print(e)
                    } else {
                        DispatchQueue.main.async {
                            self.postManager.likeRecommendPost(userEmail)
                            self.updateLikeUI(userEmail: userEmail)
                        }
                    }
                }
            } else {
                db.db.collection(K.collection).document(documentID).updateData([
                    K.likedUserIDs: FieldValue.arrayRemove([userEmail])
                ]) { error in
                    if let e = error {
                        print(e)
                    } else {
                        DispatchQueue.main.async {
                            self.postManager.dislikeRecommendPost(userEmail)
                            self.updateLikeUI(userEmail: userEmail)
                        }
                    }
                }
            }
        }
    }
    
    @objc func cameraButtonPressed() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Functions

    func updateLikeUI(userEmail: String) {
        homeView.likeCountLabel.text = String(postManager.getRecommendPost().likedUserIDs.count)
        if postManager.getRecommendPost().likedUserIDs.contains(userEmail) {
            homeView.likeButton.tintColor = .red
        } else {
            homeView.likeButton.tintColor = .gray
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - UITableView DataSource,Delegate

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.getCategoriesUsed().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.progressesTableView.dequeueReusableCell(withIdentifier: ProgressTableViewCell.identifier, for: indexPath) as! ProgressTableViewCell
        let category = categories.getCategoriesUsed()[indexPath.row]

        let totalUsage = categories.getTotalUsage()
        cell.iconLabel.text = category.name
        cell.progressBar.progress = category.usage/totalUsage
        
        return cell
    }
}

//MARK: - PickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let UserImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let result = PhotoResultViewController()
            result.userImage = UserImage
            self.navigationController?.pushViewController(result, animated: true)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
