//
//  PostDetailView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/22/23.
//

import UIKit

class PostDetailView: UIView {
    
    let postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemGray4
        return image
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postDetail: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let likeCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(postImage)
        addSubview(postDate)
        addSubview(postDetail)
        addSubview(likeButton)
        addSubview(likeCount)

        NSLayoutConstraint.activate([
            postImage.topAnchor.constraint(equalTo: topAnchor),
            postImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor),

            postDate.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 8),
            postDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            postDetail.topAnchor.constraint(equalTo: postDate.bottomAnchor, constant: 8),
            postDetail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postDetail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            likeButton.topAnchor.constraint(equalTo: postDetail.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),

            likeCount.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
            likeCount.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeCount.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
}

