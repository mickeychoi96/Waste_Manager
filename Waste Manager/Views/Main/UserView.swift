//
//  UserView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/15/23.
//

import UIKit

class UserView: UIView {
    
    let emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "EMAIL : "
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold) // 폰트 스타일 설정
        label.textColor = .darkGray // 색상 설정
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16) // 폰트 스타일 설정
        label.textColor = .black // 색상 설정
        return label
    }()
    
    let progressTitle: UILabel = {
        let label = UILabel()
        label.text = "Your Progress"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold) // 폰트 스타일 설정
        label.textColor = .black // 색상 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressesView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let myPostTitle: UILabel = {
        let label = UILabel()
        label.text = "Your Posts"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold) // 폰트 스타일 설정
        label.textColor = .black // 색상 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let myPostView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 2, height: (UIScreen.main.bounds.width / 3) - 2)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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

        emailStackView.addArrangedSubview(emailTitleLabel)
        emailStackView.addArrangedSubview(emailLabel)
        
        addSubview(emailStackView)
        addSubview(progressTitle)
        addSubview(progressesView)
        addSubview(myPostTitle)
        addSubview(myPostView)

        progressesView.register(ProgressTableViewCell.self, forCellReuseIdentifier: ProgressTableViewCell.identifier)
        myPostView.register(MyPostCollectionViewCell.self, forCellWithReuseIdentifier: MyPostCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            emailStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            
            progressTitle.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
            progressTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            progressesView.topAnchor.constraint(equalTo: progressTitle.bottomAnchor, constant: 10),
            progressesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressesView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressesView.heightAnchor.constraint(equalToConstant: 200), // 고정 높이

            myPostTitle.topAnchor.constraint(equalTo: progressesView.bottomAnchor, constant: 20),
            myPostTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            myPostView.topAnchor.constraint(equalTo: myPostTitle.bottomAnchor, constant: 10),
            myPostView.leadingAnchor.constraint(equalTo: leadingAnchor),
            myPostView.trailingAnchor.constraint(equalTo: trailingAnchor),
            myPostView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
