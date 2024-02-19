//
//  PhotoResultViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/30/23.
//

import UIKit
import FirebaseStorage

class PhotoResultViewController: UIViewController {
    
    let photoResultView = PhotoResultView()
    
    let modelHandler = ModelHandler()
    
    let categoryManager = CategoryManager()
    
    public var userImage: UIImage?
    
    var recommend: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photoResultView)
        
        NSLayoutConstraint.activate([
            photoResultView.topAnchor.constraint(equalTo: view.topAnchor),
            photoResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            photoResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        predictionRequest()
        buttonActionSetting()
        uiSetting()
    }
    
    private func buttonActionSetting() {
        photoResultView.confirmButton.addTarget(self, action: #selector(confirmResult), for: .touchUpInside)
        photoResultView.confirmButton_2.addTarget(self, action: #selector(confirmResult_2), for: .touchUpInside)
    }
    
    private func uiSetting() {
        photoResultView.resultImageView.image = userImage
    }
    
    private func predictionRequest() {
        guard let ciimageResult = CIImage(image: userImage!) else {
            fatalError("Can't convert UIImage")
        }
        
        recommend = modelHandler.detect(image: ciimageResult)
        photoResultView.resultLabel.text = recommend
    }
    
    @objc private func confirmResult() {
        presentSaveAlert()
        CameraViewController().recommend = recommend
        categoryManager.increaseCategory(name: recommend)
        self.navigationController?.pushViewController(CameraViewController(), animated: true)
    }
    
    @objc private func confirmResult_2() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentSaveAlert() {
        let alert = UIAlertController(title: "Save Photo", message: "Would you mind sending us your photos?\nI would like to provide more accurate results.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.uploadImageToStorage(self.userImage!, category: self.recommend) { result in
                switch result {
                case .success(let downloadURL):
                    print(downloadURL)
                case .failure(let error):
                    print("Error uploading image to Storage: \(error)")
                }
            }
            CameraViewController().recommend = self.recommend
            self.navigationController?.pushViewController(CameraViewController(), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            let cameraViewController = CameraViewController()
            cameraViewController.recommend = self.recommend
            self.navigationController?.pushViewController(cameraViewController, animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func uploadImageToStorage(_ image: UIImage, category: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("feedBack/\(category)/\(UUID().uuidString).jpg")
        
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
