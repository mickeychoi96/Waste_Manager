//
//  ProgressTableViewCell.swift
//  Waste Manager
//
//  Created by 최유현 on 11/9/23.
//

import UIKit

class ProgressTableViewCell: UITableViewCell {
    static let identifier = "ProgressCell"

    // 아이콘 레이블
    let iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray // 아이콘 레이블의 색상을 어두운 회색으로 조정
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium) // 폰트 스타일과 크기 조정
        return label
    }()

    // 프로그레스 바
    let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = UIColor.lightGray // 프로그레스 바의 트랙 색상을 연한 회색으로 설정
        progress.progressTintColor = UIColor(red: 102/255, green: 204/255, blue: 0/255, alpha: 1) // 진행 색상을 밝은 녹색으로 설정
        progress.layer.cornerRadius = 8
        progress.clipsToBounds = true
        progress.layer.sublayers![1].cornerRadius = 8 // 프로그레스 바 내부의 진행 부분에도 코너 라운드 적용
        progress.subviews[1].clipsToBounds = true
        return progress
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        isUserInteractionEnabled = false
        
        contentView.addSubview(iconLabel)
        contentView.addSubview(progressBar)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 32),
            
            progressBar.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 8),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 셀의 프로그레스 바 진행 상태를 업데이트하는 메서드 추가
    func setProgress(_ progress: Float, animated: Bool) {
        progressBar.setProgress(progress, animated: animated)
    }
}
