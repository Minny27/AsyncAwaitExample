//
//  PostTableViewCell.swift
//  AsyncAwaitExample
//
//  Created by SeungMin on 12/31/23.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.textColor = .black
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
        ])
    }
}
