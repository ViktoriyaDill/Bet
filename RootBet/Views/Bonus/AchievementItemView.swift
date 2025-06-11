//
//  AchievementItemView.swift
//  RootBet
//
//  Created by Пользователь on 12.06.2025.
//

import Foundation
import UIKit
import SnapKit


class AchievementItemView: UIView {
    
    private let achievement: Achievement
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    init(achievement: Achievement) {
        self.achievement = achievement
        super.init(frame: .zero)
        setupUI()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        containerView.backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = 4
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 4
        iconImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        // Constraints
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func updateUI() {
        titleLabel.text = achievement.title
        iconImageView.image = UIImage(named: achievement.iconName)
        
        if achievement.isCompleted {
            iconImageView.alpha = 1
            containerView.layer.borderColor = UIColor.systemGreen.cgColor
        } else {
            iconImageView.alpha = 0.4
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        }
    }
}
