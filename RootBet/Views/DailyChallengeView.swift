//
//  DailyChallengeView.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import Foundation
import UIKit
import SnapKit


protocol DailyChallengeViewDelegate: AnyObject {
    func didTapClaimReward(for challenge: DailyChallenge)
}

class DailyChallengeView: UIView {
    
    weak var delegate: DailyChallengeViewDelegate?
    private var challenge: DailyChallenge
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let rewardContainer = UIView()
    private let rewardIcon = UIImageView()
    private let rewardLabel = UILabel()
    
    init(challenge: DailyChallenge) {
        self.challenge = challenge
        super.init(frame: .zero)
        setupUI()
        updateProgress(challenge)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        
        containerView.backgroundColor = UIColor(hex: "#4E4A8D")
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 2
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(rewardContainer)
        
        rewardContainer.backgroundColor = UIColor(hex: "#D8D2FF")
        rewardContainer.layer.cornerRadius = 6
        rewardContainer.addSubview(rewardIcon)
        rewardContainer.addSubview(rewardLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        
        rewardIcon.image = UIImage(named: "gold-coin")
        rewardIcon.contentMode = .scaleAspectFit
        
        rewardLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        rewardLabel.textColor = .black
        rewardLabel.textAlignment = .center
        
        // Constraints
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(70)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(rewardContainer.snp.leading).offset(-12)
        }
        
        rewardContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(80)
            make.height.equalTo(36)
        }
        
        rewardIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        rewardLabel.snp.makeConstraints { make in
            make.leading.equalTo(rewardIcon.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    func updateProgress(_ challenge: DailyChallenge) {
        self.challenge = challenge
        
        titleLabel.text = challenge.description
        rewardLabel.text = "\(challenge.reward)"
        
        if challenge.isRewardClaimed {
            rewardContainer.backgroundColor = UIColor(hex: "#473B70")
        } else if challenge.isCompleted {
            rewardContainer.backgroundColor = UIColor(hex: "#8346BC")
        } else {
            containerView.backgroundColor = UIColor(hex: "#4E4A8D")
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            rewardContainer.backgroundColor = UIColor(hex: "#D8D2FF")
        }
    }
    
    @objc private func containerTapped() {
        if challenge.isCompleted && !challenge.isRewardClaimed {
            delegate?.didTapClaimReward(for: challenge)
        }
    }
}
