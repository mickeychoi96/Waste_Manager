//
//  RecommendPostCollectionViewCell.swift
//  Waste Manager
//
//  Created by 최유현 on 12/1/23.
//

import UIKit

class RecommendPostCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendPostCell"
    
    // 추천 포스트 스택뷰
    let recommendPostStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    // 포스트 이미지뷰
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // 포스트 날짜 레이블
    let postDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    // 포스트 상세정보 레이블
    let postDetailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // 좋아요 스택뷰
    let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading // 좋아요 버튼과 숫자를 왼쪽으로 정렬
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // 좋아요 버튼
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    // 좋아요 개수 레이블
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .gray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(recommendPostStackView)
        
        recommendPostStackView.addArrangedSubview(postImageView)
        recommendPostStackView.addArrangedSubview(postDateLabel)
        recommendPostStackView.addArrangedSubview(postDetailLabel)
        recommendPostStackView.addArrangedSubview(likeStackView)
        
        likeStackView.addArrangedSubview(likeButton)
        likeStackView.addArrangedSubview(likeCountLabel)
        
        NSLayoutConstraint.activate([
            recommendPostStackView.topAnchor.constraint(equalTo: topAnchor),
            recommendPostStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recommendPostStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recommendPostStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                        
            likeStackView.leadingAnchor.constraint(equalTo: recommendPostStackView.leadingAnchor),
        ])
    }
}
