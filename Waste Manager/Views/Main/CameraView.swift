//
//  CameraView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/16/23.
//

import UIKit

class CameraView: UIView {
    
    let resultImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let gptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recommendPost: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
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
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 16)
        text.textColor = .darkGray
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let postLikes: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        backgroundColor = .systemBackground // 시스템 배경색 사용
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(resultImage)
        addSubview(gptLabel)
        addSubview(recommendPost)

        recommendPost.addArrangedSubview(postImage)
        recommendPost.addArrangedSubview(postDate)
        recommendPost.addArrangedSubview(postDetail)
        postLikes.addArrangedSubview(likeButton)
        postLikes.addArrangedSubview(likeCount)
        recommendPost.addArrangedSubview(postLikes)

        // Auto Layout 설정
        NSLayoutConstraint.activate([
            resultImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            resultImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            resultImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            resultImage.heightAnchor.constraint(equalTo: resultImage.widthAnchor),

            gptLabel.topAnchor.constraint(equalTo: resultImage.bottomAnchor, constant: 10),
            gptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            recommendPost.topAnchor.constraint(equalTo: gptLabel.bottomAnchor, constant: 20),
            recommendPost.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recommendPost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            recommendPost.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }
}

