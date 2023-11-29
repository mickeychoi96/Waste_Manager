//
//  NewPostView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/16/23.
//

import UIKit

class NewPostView: UIView {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemGray4
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return textView
    }()
    
    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
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
        
        addSubview(imageView)
        addSubview(textView)
        addSubview(categoryPicker)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            textView.topAnchor.constraint(equalTo: imageView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            categoryPicker.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            categoryPicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            categoryPicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}

