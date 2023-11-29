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
    
    var posts = Posts.posts
    
    var randomInt = 0
    
    let db = Firestore.firestore()

    let used = Categories.categoriesUsed
    
    let imagePicker = UIImagePickerController()
            
    override func viewDidLoad() {
        super.viewDidLoad()

        posts = []
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false

        // Firestore에서 데이터 가져오기
        db.collection(K.collection).order(by: K.date, descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let imageURL = data[K.imageUI] as? String, let date = data[K.date] as? String, let text = data[K.text] as? String, let user = data[K.userID] as? String, let category = data[K.category] as? String, let likes = data[K.likedUserIDs] as? [String] {
                        let likesSet = Set(likes)
                        let newPost = Post(userID: user, imageUI: imageURL, date: date, text: text, likedUserIDs: likesSet, category: category, document: document.documentID)
                        self.posts.append(newPost)
                    }
                }

                // Firestore 데이터 로드 완료 후 UI 업데이트
                DispatchQueue.main.async {
                    self.updateHomeView()
                }
            }
        }

        // 나머지 UI 설정
        setupNavigationBar()
        setupHomeViewLayout()
        
        homeView.likeButton.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
        homeView.cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
    }

    func updateHomeView() {
        if !posts.isEmpty {
            randomInt = Int.random(in: 0..<posts.count)
            let post = posts[randomInt]

            if let email = Auth.auth().currentUser?.email {
                self.updateLikeUI(for: self.randomInt, userEmail: email)
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
        self.navigationItem.rightBarButtonItems = [barButtonItem]
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
    
    @objc func recommendPostTapped() {
        let postDetail = PostDetailViewController()
        postDetail.post = posts[randomInt]
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
    
    @objc func heartButtonPressed() {
        if let userEmail = Auth.auth().currentUser?.email {
            let index = self.randomInt
            let documentID = posts[index].document
            let isLiked = posts[index].likedUserIDs.contains(userEmail)

            if !isLiked {
                db.collection(K.collection).document(documentID).updateData([
                    K.likedUserIDs: FieldValue.arrayUnion([userEmail])
                ]) { error in
                    if let e = error {
                        print(e)
                    } else {
                        DispatchQueue.main.async {
                            self.posts[index].likedUserIDs.insert(userEmail)
                            self.updateLikeUI(for: index, userEmail: userEmail)
                        }
                    }
                }
            } else {
                db.collection(K.collection).document(documentID).updateData([
                    K.likedUserIDs: FieldValue.arrayRemove([userEmail])
                ]) { error in
                    if let e = error {
                        print(e)
                    } else {
                        DispatchQueue.main.async {
                            self.posts[index].likedUserIDs.remove(userEmail)
                            self.updateLikeUI(for: index, userEmail: userEmail)
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

    func updateLikeUI(for index: Int, userEmail: String) {
        homeView.likeCountLabel.text = String(posts[index].likedUserIDs.count)
        //알고리즘이 잘못됨
        if posts[index].likedUserIDs.contains(userEmail) {
            homeView.likeButton.tintColor = .red
        } else {
            homeView.likeButton.tintColor = .gray
        }
    }

}

//MARK: - UITableView DataSource,Delegate

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return used.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.progressesTableView.dequeueReusableCell(withIdentifier: ProgressTableViewCell.identifier, for: indexPath) as! ProgressTableViewCell
        let (iconLabel, progress) = (used[indexPath.row])
        
        cell.iconLabel.text = iconLabel.name
        cell.progressBar.progress = Float(progress)

        return cell
    }
}

//MARK: - PickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let UserImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let result = CameraViewController()
            result.UserImage = UserImage
            self.navigationController?.pushViewController(result, animated: true)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
