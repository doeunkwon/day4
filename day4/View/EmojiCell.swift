//
//  EmojiCell.swift
//  day4
//
//  Created by Doeun Kwon on 2024-09-15.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    
    static let identifier = "emojiCell"
    
    let emojiView: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        contentView.addSubview(emojiView)
        contentView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
        
            emojiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
        ])
    }
    
    func setBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
}
