//
//  DailyBonusCell.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import UIKit
import SnapKit

class DailyBonusCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let chestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sigmarOne(16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let glowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.alpha = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        
        contentView.addSubview(glowView)
        contentView.addSubview(containerView)
        containerView.addSubview(chestImageView)
        containerView.addSubview(dayLabel)
        
        glowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        chestImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(dayLabel.snp.top).offset(-4)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(24)
        }
    }
    
    func configure(with bonus: DailyBonus,
                   isCurrentDay: Bool,
                   isCompleted: Bool) {


        if bonus.day == 7 {
            chestImageView.image = UIImage(
                named: isCompleted ? "treasure_chest_mega_opened" : "treasure_chest_mega"
            )
        } else {
            chestImageView.image = UIImage(
                named: isCompleted ? "treasure_chest_mega_opened" : "treasure_chest_closed"
            )
        }
        dayLabel.text = "DAY \(bonus.day)"

        
        if isCurrentDay {
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.white.cgColor
        } else {
            containerView.layer.borderWidth = 0
            glowView.layer.removeAllAnimations()
            glowView.alpha = 0
        }
    }

}
