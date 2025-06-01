//
//  MemoryCardCell.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit

class MemoryCardCell: UICollectionViewCell {
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(symbolLabel)
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = UIColor.systemPurple
        
        symbolLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with card: MemoryCard) {
        if card.isFlipped || card.isMatched {
            symbolLabel.text = card.symbol
            contentView.backgroundColor = card.color
        } else {
            symbolLabel.text = "?"
            contentView.backgroundColor = UIColor.systemPurple
        }
        
        if card.isMatched {
            contentView.alpha = 0.6
        } else {
            contentView.alpha = 1.0
        }
    }
}
