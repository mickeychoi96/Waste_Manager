//
//  PhotoResultView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/30/23.
//

import UIKit

class PhotoResultView: UIView {
    
    let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Am I right?"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yes, it is", for: .normal)
        button.backgroundColor = UIColor(named: Color.mainColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        return button
    }()
    
    let confirmButton_2: UIButton = {
        let button = UIButton()
        button.setTitle("No, it isn't", for: .normal)
        button.backgroundColor = UIColor(named: Color.mainColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        return button
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
        
        addSubview(resultImageView)
        addSubview(resultLabel)
        addSubview(confirmButton)
        addSubview(confirmButton_2)

        NSLayoutConstraint.activate([
            resultImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            resultImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            resultImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            resultImageView.heightAnchor.constraint(equalToConstant: 400),
            
            resultLabel.topAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            confirmButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            
            confirmButton_2.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 20),
            confirmButton_2.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton_2.widthAnchor.constraint(equalToConstant: 200),
            confirmButton_2.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

