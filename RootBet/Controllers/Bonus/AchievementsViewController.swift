//
//  AchievementsViewController.swift
//  RootBet
//
//  Created by Пользователь on 12.06.2025.
//

import UIKit
import SnapKit

class AchievementsViewController: BaseViewController {
    
    // MARK: - Properties
    private var coinLabel = UILabel()
    private var coinContainer = UIView()
    private var crystalLabel = UILabel()
    private var crystalContainer = UIView()
    
    private var achievements: [Achievement] = []
    
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
        label.text = "Achievements"
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
    
    // Achievement sections
    private let gameProgressSection = AchievementSectionView(title: "Game Progress")
    private let dailyWeeklySection = AchievementSectionView(title: "Daily & Weekly Activity")
    private let recordSection = AchievementSectionView(title: "Record")
    private let specialRewardsSection = AchievementSectionView(title: "Special Rewards")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createHeaderView()
        setupConstraints()
        loadAchievements()
        updateUI()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        checkAchievementProgress()
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
        contentView.addSubview(gameProgressSection)
        contentView.addSubview(dailyWeeklySection)
        contentView.addSubview(recordSection)
        contentView.addSubview(specialRewardsSection)
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
            make.width.equalToSuperview().multipliedBy(0.28)
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
            make.width.equalToSuperview().multipliedBy(0.28)
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
        
        gameProgressSection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        dailyWeeklySection.snp.makeConstraints { make in
            make.top.equalTo(gameProgressSection.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        recordSection.snp.makeConstraints { make in
            make.top.equalTo(dailyWeeklySection.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        specialRewardsSection.snp.makeConstraints { make in
            make.top.equalTo(recordSection.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(achievementProgressUpdated),
            name: NSNotification.Name("AchievementProgressUpdated"),
            object: nil
        )
    }
    
    // MARK: - Data Management
    private func loadAchievements() {
        achievements = AchievementManager.shared.getAllAchievements()
        setupAchievementSections()
    }
    
    private func setupAchievementSections() {
        let gameProgressAchievements = achievements.filter { $0.category == .gameProgress }
        let dailyWeeklyAchievements = achievements.filter { $0.category == .dailyWeekly }
        let recordAchievements = achievements.filter { $0.category == .record }
        let specialRewardsAchievements = achievements.filter { $0.category == .specialRewards }
        
        gameProgressSection.setAchievements(gameProgressAchievements)
        dailyWeeklySection.setAchievements(dailyWeeklyAchievements)
        recordSection.setAchievements(recordAchievements)
        specialRewardsSection.setAchievements(specialRewardsAchievements)
    }
    
    private func updateUI() {
        coinLabel.text = "\(UserDataService.shared.coins)"
        crystalLabel.text = "\(UserDataService.shared.crystals)"
        
        // Update achievements
        achievements = AchievementManager.shared.getAllAchievements()
        setupAchievementSections()
    }
    
    private func checkAchievementProgress() {
        AchievementManager.shared.checkAllAchievements()
        updateUI()
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func achievementProgressUpdated(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
}

// MARK: - Achievement Section View
class AchievementSectionView: UIView {
    private let titleLabel = UILabel()
    private let gridContainer = UIView()
    private var achievementViews: [AchievementItemView] = []
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        addSubview(titleLabel)
        addSubview(gridContainer)
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        gridContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setAchievements(_ achievements: [Achievement]) {
        // Clear existing views
        achievementViews.forEach { $0.removeFromSuperview() }
        achievementViews.removeAll()
        
        let itemsPerRow = 4
        let spacing: CGFloat = 12
        let itemWidth = (UIScreen.main.bounds.width - 32 - CGFloat(itemsPerRow - 1) * spacing) / CGFloat(itemsPerRow)
        
        for (index, achievement) in achievements.enumerated() {
            let achievementView = AchievementItemView(achievement: achievement)
            achievementViews.append(achievementView)
            gridContainer.addSubview(achievementView)
            
            let row = index / itemsPerRow
            let column = index % itemsPerRow
            
            achievementView.snp.makeConstraints { make in
                make.width.height.equalTo(itemWidth)
                make.leading.equalToSuperview().offset(CGFloat(column) * (itemWidth + spacing))
                make.top.equalToSuperview().offset(CGFloat(row) * (itemWidth + spacing + 20))
                
                if index == achievements.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview()
                }
            }
        }
        
        // Update container height
        let rows = (achievements.count + itemsPerRow - 1) / itemsPerRow
        let totalHeight = CGFloat(rows) * (itemWidth + 20) + CGFloat(max(0, rows - 1)) * spacing
        
        gridContainer.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(totalHeight)
            make.bottom.equalToSuperview()
        }
    }
}


// MARK: - Game Integration Helper

extension AchievementsViewController {
    static func updateAchievementProgress(type: Achievement.AchievementType, progress: Int) {
        AchievementManager.shared.updateProgress(type: type, progress: progress)
    }
}
