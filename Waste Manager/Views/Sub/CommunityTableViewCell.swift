//
//  CommunityTableViewCell.swift
//  Waste Manager
//
//  Created by 최유현 on 11/10/23.
//

import UIKit

class CommunityTableViewCell: UITableViewCell {

    static let identifier = "CommunityCell"
    
    // 추천 포스트 스택뷰
    let recommendPost: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    // 포스트 이미지뷰
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    // 포스트 날짜 레이블
    let postDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .darkGray
        return label
    }()
    
    // 포스트 상세정보 레이블
    let postDetail: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .gray
        label.numberOfLines = 3
        return label
    }()
    
    // 좋아요 스택뷰
    let postLikes: UIStackView = {
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
    let likeCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .gray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .systemBackground
        recommendPost.addArrangedSubview(postImage)
        recommendPost.addArrangedSubview(postDate)
        recommendPost.addArrangedSubview(postDetail)
        
        recommendPost.addArrangedSubview(postLikes)
        
        addSubview(recommendPost)
        
        NSLayoutConstraint.activate([
            postImage.heightAnchor.constraint(equalToConstant: 200),
            
            recommendPost.topAnchor.constraint(equalTo: topAnchor),
            recommendPost.leadingAnchor.constraint(equalTo: leadingAnchor),
            recommendPost.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            recommendPost.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            postDetail.topAnchor.constraint(equalTo: postDate.bottomAnchor, constant: 20),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postImage.image = UIImage(named: "Gray")
        postDate.text = "0000"
        postDetail.text = "default detail"
        likeCount.text = "00"
        likeButton.tintColor = .gray
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
