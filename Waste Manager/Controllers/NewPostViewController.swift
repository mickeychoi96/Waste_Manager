//
//  NewPostViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/16/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class NewPostViewController: UIViewController, UINavigationControllerDelegate {
    
    let newPostView = NewPostView()
        
    let db = Firestore.firestore()
    
    let imagePicker = UIImagePickerController()
    
    let categories = Categories.categories
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(newPostView)
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        newPostView.categoryPicker.dataSource = self
        newPostView.categoryPicker.delegate = self
        
        NSLayoutConstraint.activate([
            newPostView.topAnchor.constraint(equalTo: view.topAnchor),
            newPostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newPostView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newPostView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        newPostView.imageView.addGestureRecognizer(imageTapGesture)
        
        let postButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(postButtonTapped))
        postButton.image = UIImage(systemName: "plus.app")
        
        self.navigationItem.rightBarButtonItem = postButton
    }
    
    @objc func postButtonTapped() {
        if let image = newPostView.imageView.image, let detail = newPostView.textView.text {
            uploadImageToStorage(image) { result in
                switch result {
                case .success(let downloadURL):
                    let post = Post(userID: Auth.auth().currentUser!.email!, imageUI: downloadURL.absoluteString, date: Date().description, text: detail, likedUserIDs: [], category: self.category ?? "Default", document: "")
                    do {
                        try self.db.collection("post").document().setData(from: post)
                    } catch let error {
                        print("Error writing post to Firestore: \(error)")
                    }
                case .failure(let error):
                    print("Error uploading image to Storage: \(error)")
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func imageViewTapped() {
        print("it works")
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Upload image
    
    func uploadImageToStorage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error!))
                return
            }
            
            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
}

//MARK: - PickerControllerDelegate

extension NewPostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let UserImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newPostView.imageView.image = UserImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIPickerView Extension

extension NewPostViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension NewPostViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.category = categories[row].name
    }
}
