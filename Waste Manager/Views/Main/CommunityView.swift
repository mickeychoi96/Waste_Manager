//
//  CommunityView.swift
//  Waste Manager
//
//  Created by 최유현 on 11/10/23.
//

import UIKit

class CommunityView: UIView {
        
    let communities: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(communities)
        
        communities.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            communities.topAnchor.constraint(equalTo: topAnchor),
            communities.leadingAnchor.constraint(equalTo: leadingAnchor),
            communities.trailingAnchor.constraint(equalTo: trailingAnchor),
            communities.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
