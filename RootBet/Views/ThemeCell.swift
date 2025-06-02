//
//  ThemeCell.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import Foundation
import UIKit

class ThemeCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let themeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let checkmarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.circle.fill")
        iv.tintColor = UIColor.systemPurple
        iv.isHidden = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(themeLabel)
        containerView.addSubview(checkmarkImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }
        
        themeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with theme: String, isSelected: Bool) {
        themeLabel.text = theme
        checkmarkImageView.isHidden = !isSelected
        
        if isSelected {
            containerView.layer.borderColor = UIColor.systemPurple.cgColor
            containerView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
        } else {
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        }
    }
}
