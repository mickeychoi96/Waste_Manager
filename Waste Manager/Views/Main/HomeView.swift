//
//  HomeView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/8/23.
//

import UIKit

class HomeView: UIView {
    
    // 타이틀 레이블
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ReJoycle"
        label.textAlignment = .center
        label.textColor = UIColor(named: Color.brightGreen) // 밝은 녹색
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 45) // HelveticaNeue-Bold 폰트 사용
        return label
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Happy Recycling Time!", for: .normal)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        button.backgroundColor = UIColor(red: 93/255, green: 173/255, blue: 236/255, alpha: 1)// Blue Jeans
        button.titleLabel?.textAlignment = .center
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
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
        imageView.contentMode = .scaleAspectFit
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
    
    private let postSeparatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray // 구분선 색상 설정
        return view
    }()
    
    // 재활용 진행 상태 테이블뷰
    let progressesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(cameraButton)
        addSubview(recommendPostStackView)
        addSubview(progressesTableView)
        addSubview(postSeparatorLine)
        
        recommendPostStackView.addArrangedSubview(postImageView)
        recommendPostStackView.addArrangedSubview(postDateLabel)
        recommendPostStackView.addArrangedSubview(postDetailLabel)
        recommendPostStackView.addArrangedSubview(likeStackView)
        
        likeStackView.addArrangedSubview(likeButton)
        likeStackView.addArrangedSubview(likeCountLabel)
        
        progressesTableView.register(ProgressTableViewCell.self, forCellReuseIdentifier: ProgressTableViewCell.identifier)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cameraButton.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10),
            cameraButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 300),
            
            recommendPostStackView.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 10),
            recommendPostStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recommendPostStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            postImageView.heightAnchor.constraint(equalToConstant: 200),
            
            progressesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            progressesTableView.topAnchor.constraint(equalTo: postSeparatorLine.bottomAnchor, constant: 20),
            progressesTableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 180),

            postSeparatorLine.topAnchor.constraint(equalTo: recommendPostStackView.bottomAnchor, constant: 20),
            postSeparatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            postSeparatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            postSeparatorLine.heightAnchor.constraint(equalToConstant: 1), // 선의 높이
            
            likeStackView.leadingAnchor.constraint(equalTo: recommendPostStackView.leadingAnchor),
        ])
    }
}

