//
//  AvatarCell.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import UIKit
import SnapKit

class AvatarCell: UICollectionViewCell {
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = iv.frame.width / 2
        return iv
    }()
    
    private let selectionBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = view.frame.width / 2
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
        contentView.layer.cornerRadius = contentView.frame.width / 2
        contentView.clipsToBounds = true
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(selectionBorder)
        
        avatarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        selectionBorder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        selectionBorder.layer.cornerRadius = selectionBorder.frame.width / 2
    }
    
    
    func configure(with avatarName: String, isSelected: Bool) {
        avatarImageView.image = UIImage(named: avatarName) ?? UIImage(named: "photoUser")
        selectionBorder.isHidden = !isSelected
        contentView.transform = isSelected ? CGAffineTransform(scaleX: 1.1, y: 1.1) : .identity
    }
}
