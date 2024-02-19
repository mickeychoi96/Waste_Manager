//
//  CameraView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/16/23.
//

import UIKit

class CameraView: UIView {
    
    let gptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkGray
        label.layer.borderWidth = 2
        label.layer.borderColor = CGColor(red: 93/255, green: 173/255, blue: 236/255, alpha: 1)// Blue Jeans
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gptRegenerateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Regenerate the Answer", for: .normal)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        button.backgroundColor = UIColor(red: 93/255, green: 173/255, blue: 236/255, alpha: 1)// Blue Jeans
        button.titleLabel?.textAlignment = .center
        button.tintColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    let recommendPost: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 300, height: 300) // 셀의 크기 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.decelerationRate = .fast
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
        
        addSubview(gptLabel)
        addSubview(gptRegenerateButton)
        addSubview(recommendPost)
        
        recommendPost.register(RecommendPostCollectionViewCell.self, forCellWithReuseIdentifier: RecommendPostCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            gptLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            gptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            gptRegenerateButton.topAnchor.constraint(equalTo: gptLabel.bottomAnchor, constant: 10),
            gptRegenerateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            gptRegenerateButton.widthAnchor.constraint(equalToConstant: 300),
            
            recommendPost.topAnchor.constraint(equalTo: gptRegenerateButton.bottomAnchor, constant: 10),
            recommendPost.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recommendPost.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            recommendPost.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

