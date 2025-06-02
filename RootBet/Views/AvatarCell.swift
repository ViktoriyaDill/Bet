//
//  AvatarCell.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    private let avatarImageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 12
            return iv
        }()
        
        private let selectionBorder: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.layer.borderWidth = 3
            view.layer.borderColor = UIColor.systemPurple.cgColor
            view.layer.cornerRadius = 12
            view.isHidden = true
            return view
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupUI() {
            contentView.addSubview(avatarImageView)
            contentView.addSubview(selectionBorder)
            
            avatarImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(4)
            }
            
            selectionBorder.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        func configure(with avatarName: String, isSelected: Bool) {
            avatarImageView.image = UIImage(named: avatarName) ?? UIImage(named: "photoUser")
            selectionBorder.isHidden = !isSelected
            
            if isSelected {
                contentView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } else {
                contentView.transform = .identity
            }
        }
}
