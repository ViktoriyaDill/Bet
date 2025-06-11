//
//  EffectCell.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import Foundation
import UIKit

class EffectCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let effectLabel: UILabel = {
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
    
    private let previewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        return view
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
        containerView.addSubview(effectLabel)
        containerView.addSubview(checkmarkImageView)
        containerView.addSubview(previewView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }
        
        effectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        previewView.snp.makeConstraints { make in
            make.trailing.equalTo(checkmarkImageView.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with effect: String, isSelected: Bool) {
        effectLabel.text = effect
        checkmarkImageView.isHidden = !isSelected
        
        // Configure preview based on effect
        switch effect {
        case "Neon Glow":
            previewView.backgroundColor = UIColor.cyan.withAlphaComponent(0.6)
            previewView.layer.shadowColor = UIColor.cyan.cgColor
            previewView.layer.shadowRadius = 8
            previewView.layer.shadowOpacity = 0.8
        case "Ice Crystals":
            previewView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.6)
            previewView.layer.shadowColor = UIColor.white.cgColor
            previewView.layer.shadowRadius = 4
            previewView.layer.shadowOpacity = 0.6
        case "Aurora Effect":
            previewView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.6)
            previewView.layer.shadowColor = UIColor.systemPurple.cgColor
            previewView.layer.shadowRadius = 6
            previewView.layer.shadowOpacity = 0.7
        case "No Effects":
            previewView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
            previewView.layer.shadowRadius = 0
            previewView.layer.shadowOpacity = 0
        default:
            previewView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        }
        
        if isSelected {
            containerView.layer.borderColor = UIColor.systemPurple.cgColor
            containerView.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.2)
        } else {
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        }
    }
}
