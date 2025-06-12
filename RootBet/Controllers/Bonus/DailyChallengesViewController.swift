//
//  DailyChallengesViewController.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import UIKit
import SnapKit

class DailyChallengesViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var coinLabel = UILabel()
    private var coinContainer = UIView()
    private var crystalLabel = UILabel()
    private var crystalContainer = UIView()
    
    private var challenges: [DailyChallenge] = []
    private var challengeViews: [DailyChallengeView] = []
    
    // MARK: - UI Elements
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prevBtn"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    private let headerView: UIView = {
        let stack = UIView()
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Challenges"
        label.font = UIFont.sigmarOne(20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createHeaderView()
        setupConstraints()
        loadChallenges()
        updateUI()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        checkChallengeProgress()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func createHeaderView() {
        headerView.addSubview(backButton)
        
        let coinContainer = UIView()
        coinContainer.backgroundColor = UIColor(red: 0.85, green: 0.82, blue: 1.00, alpha: 1.00)
        coinContainer.layer.cornerRadius = 6
        coinContainer.clipsToBounds = true
        self.coinContainer = coinContainer
        headerView.addSubview(coinContainer)
        
        let coinIcon = UIImageView()
        coinIcon.contentMode = .scaleAspectFit
        coinIcon.image = UIImage(named: "gold-coin")
        coinContainer.addSubview(coinIcon)
        
        let coinsLabel = UILabel()
        coinsLabel.font = UIFont.sigmarOne(16)
        coinsLabel.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        coinContainer.addSubview(coinsLabel)
        self.coinLabel = coinsLabel
        
        let crystalContainer = UIView()
        crystalContainer.backgroundColor = UIColor(red: 0.85, green: 0.82, blue: 1.00, alpha: 1.00)
        crystalContainer.layer.cornerRadius = 6
        crystalContainer.clipsToBounds = true
        self.crystalContainer = crystalContainer
        headerView.addSubview(crystalContainer)
        
        let crystalIcon = UIImageView()
        crystalIcon.contentMode = .scaleAspectFit
        crystalIcon.image = UIImage(named: "diam-coin")
        crystalContainer.addSubview(crystalIcon)
        
        let crystalsLabel = UILabel()
        crystalsLabel.font = UIFont.sigmarOne(16)
        crystalsLabel.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        crystalContainer.addSubview(crystalsLabel)
        self.crystalLabel = crystalsLabel
        
        // Constraints for header
        backButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
        }
        
        crystalIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(crystalIcon.snp.width)
        }
        crystalsLabel.snp.makeConstraints { make in
            make.leading.equalTo(crystalIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(6)
        }
        crystalContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(coinContainer.snp.width).multipliedBy(0.48)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.trailing.equalToSuperview()
        }
        
        coinIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(coinIcon.snp.width)
        }
        coinsLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(6)
        }
        coinContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(crystalContainer.snp.leading).offset(-6)
            make.height.equalTo(coinContainer.snp.width).multipliedBy(0.48)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    private func setupConstraints() {
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    private func setupNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dayChanged),
            name: NSNotification.Name("DayChanged"),
            object: nil
        )
    }
    
    // MARK: - Data Management
    private func loadChallenges() {
        challenges = DailyChallengeManager.shared.getDailyChallenges()
        createChallengeViews()
    }
    
    private func createChallengeViews() {
        // Clear existing views
        challengeViews.forEach { $0.removeFromSuperview() }
        challengeViews.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create new challenge views
        for challenge in challenges {
            let challengeView = DailyChallengeView(challenge: challenge)
            challengeView.delegate = self
            challengeViews.append(challengeView)
            stackView.addArrangedSubview(challengeView)
        }
    }
    
    private func updateUI() {
        coinLabel.text = "\(UserDataService.shared.coins)"
        crystalLabel.text = "\(UserDataService.shared.crystals)"
        
        // Update challenge views
        for (index, challengeView) in challengeViews.enumerated() {
            if index < challenges.count {
                challengeView.updateProgress(challenges[index])
            }
        }
    }
    
    private func checkChallengeProgress() {
        for challenge in challenges {
            DailyChallengeManager.shared.checkChallengeProgress(challenge)
        }
        updateUI()
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dayChanged() {
        DailyChallengeManager.shared.resetDailyChallenges()
        loadChallenges()
        updateUI()
    }
}

// MARK: - DailyChallengeViewDelegate
extension DailyChallengesViewController: DailyChallengeViewDelegate {
    func didTapClaimReward(for challenge: DailyChallenge) {
        guard challenge.isCompleted && !challenge.isRewardClaimed else { return }
        
        // Claim reward
        DailyChallengeManager.shared.claimReward(for: challenge)
        
        // Show reward animation
        showRewardAnimation(for: challenge)
        
        // Update UI
        updateUI()
    }
    
    private func showRewardAnimation(for challenge: DailyChallenge) {
        // Add coins with animation
        UserDataService.shared.addCoins(challenge.reward)
        
        // Create flying coins animation
        let rewardView = UILabel()
        rewardView.text = "+\(challenge.reward)"
        rewardView.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        rewardView.textColor = .systemYellow
        rewardView.textAlignment = .center
        view.addSubview(rewardView)
        
        rewardView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        rewardView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            rewardView.alpha = 1
            rewardView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.8, animations: {
                rewardView.center = self.coinContainer.center
                rewardView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    rewardView.alpha = 0
                    self.coinContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }) { _ in
                    rewardView.removeFromSuperview()
                    UIView.animate(withDuration: 0.2) {
                        self.coinContainer.transform = .identity
                    }
                }
            }
        }
    }
}

