//
//  CameraViewController.swift
//  Waste Manager
//
//  Created by 최유현 on 11/6/23.
//

import UIKit

class CameraViewController: UIViewController {

    let cameraView = CameraView()
    
    let openAIService = OpenAIService()
    
    let postManager = PostManager.shared
        
    public var recommend: String?
    
    var categoryPosts: [Post]?
    
    var gptQuestion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(cameraView)
        
        cameraView.recommendPost.dataSource = self
        cameraView.recommendPost.delegate = self
                
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        categoryPosts = postManager.getPostsByCategory(recommend ?? "")
        gptQuestion = "Please tell me three things that can be made creatively by recycling \(recommend ?? "") along with a Up to 150 characters explanation and different with before answer."
        
        gptLayoutSetting(gptQuestion)
        
        cameraView.gptRegenerateButton.addTarget(self, action: #selector(regenerateButtonPresssed), for: .touchUpInside)
    }
    
    func gptLayoutSetting(_ question: String) {
        self.openAIService.getAIService(prompt: question) { answer in
            DispatchQueue.main.async {
                self.cameraView.gptLabel.text = answer
            }
        }
    }
    
    @objc func regenerateButtonPresssed() {
        gptLayoutSetting(gptQuestion)
    }
}

//MARK: - CollectionView Extension

extension CameraViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = categoryPosts?.count
        return min(count ?? 0, 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cameraView.recommendPost.dequeueReusableCell(withReuseIdentifier: RecommendPostCollectionViewCell.identifier, for: indexPath) as! RecommendPostCollectionViewCell
        
        let post = categoryPosts?[indexPath.row]
        
        let image = post?.imageUI
        let date = post?.date
        let text = post?.text
        
        cell.postDateLabel.text = date
        cell.postDetailLabel.text = text
        
        if let imageUrl = URL(string: image ?? "") {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.postImageView.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
}

extension CameraViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postDetail = PostDetailViewController()
        postDetail.post = categoryPosts?[indexPath.row]
        self.navigationController?.pushViewController(postDetail, animated: true)
    }
}
