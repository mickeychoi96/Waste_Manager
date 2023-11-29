//
//  MyPostCollectionViewCell.swift
//  Waste Manager
//
//  Created by 최유현 on 11/13/23.
//

import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    
    static let identifier = "PostCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground

        imageView = UIImageView(frame: bounds)
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
