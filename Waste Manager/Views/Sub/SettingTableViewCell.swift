//
//  SettingTableViewCell.swift
//  Waste Manager
//
//  Created by 최유현 on 11/15/23.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    static let identifier = "SettingTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        backgroundColor = .systemBackground
        textLabel?.text = title
    }

}
