//
//  DailyBonusViewController.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//


import UIKit
import SnapKit
import RealmSwift


class DailyBonusViewController: BaseViewController {
    
    // MARK: - Properties
    private var coinLabel = UILabel()
    private var coinContainer = UIView()
    private var crystalLabel = UILabel()
    private var crystalContainer = UIView()
    
    
    private var currentDay = 1
    private var hasClaimed = false
    private var countdownTimer: Timer?
    private var timeRemaining: TimeInterval = 0
    
    // View states
    private var isShowingReward = false
    
    // Animation data
    private var counterAnimationData: CounterAnimationData?
    
    // Bonus types for each day
    private let dailyBonuses: [DailyBonus] = [
        DailyBonus(day: 1, type: .coins, amount: 500),
        DailyBonus(day: 2, type: .crystals, amount: 5),
        DailyBonus(day: 3, type: .infiniteLife15, amount: 15),
        DailyBonus(day: 4, type: .infiniteLife30, amount: 30),
        DailyBonus(day: 5, type: .timeBonus5, amount: 5),
        DailyBonus(day: 6, type: .timeBonus10, amount: 10),
        DailyBonus(day: 7, type: .megaReward, amount: 0)
    ]
    
    private let availableBonusTypes: [DailyBonus.BonusType] = [
        .coins, .crystals, .infiniteLife15, .infiniteLife30, .timeBonus5, .timeBonus10
    ]
    
    // Day 7 selected bonus (cached)
    private var day7Bonus: DailyBonus?
    
    // MARK: - Supporting Types
    enum BonusAnimationType {
        case coins
        case crystals
        case infiniteLife
        case timeBonus
        case megaReward
    }
    
    struct CounterAnimationData {
        let label: UILabel
        let startValue: Int
        let endValue: Int
        let startTime: CFTimeInterval
        let duration: TimeInterval
        let displayLink: CADisplayLink
    }
    
    // MARK: - Cached Day 7 Bonus
    struct CachedDay7Bonus: Codable {
        let type: DailyBonus.BonusType
        let amount: Int
    }
    
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
        label.text = "Daily Bonus"
        label.font = UIFont.sigmarOne(20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // Collection view for chest grid
    private let bonusGrid: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // Reward view (shown when chest is opened)
    private let rewardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#4E4A8D")
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        return view
    }()
    
    private let rewardChestImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "treasure_chest_mega_opened")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rewardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Bonus Unlocked!"
        label.font = UIFont.sigmarOne(16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let rewardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Claim your reward now and keep the streak going!"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let rewardAmountContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#D8D2FF")
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let rewardIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rewardAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let claimButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Claim", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#A77BCA")
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        return button
    }()
    
    private var countdownEndDate: Date? {
        get { UserDefaults.standard.object(forKey: "DailyBonusEndDate") as? Date }
        set {
            UserDefaults.standard.set(newValue, forKey: "DailyBonusEndDate")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createHeaderView()
        setupConstraints()
        setupCollectionView()
        loadDailyBonusData()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countdownTimer?.invalidate()
        counterAnimationData?.displayLink.invalidate()
    }
    
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(titleLabel)
        view.addSubview(bonusGrid)
        view.addSubview(claimButton)
        
        view.addSubview(rewardContainer)
        rewardContainer.isHidden = true
        rewardContainer.alpha = 0
        
        rewardContainer.addSubview(rewardChestImage)
        rewardContainer.addSubview(rewardTitleLabel)
        rewardContainer.addSubview(rewardDescriptionLabel)
        rewardContainer.addSubview(rewardAmountContainer)
        rewardAmountContainer.addSubview(rewardIcon)
        rewardAmountContainer.addSubview(rewardAmountLabel)
        
        // Actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        claimButton.addTarget(self, action: #selector(claimButtonTapped), for: .touchUpInside)
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
        headerView.addSubview(coinContainer)
        headerView.addSubview(crystalContainer)
        
        // 1) Avatar
        
        backButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
        }
        
        // 3) Crystal Container
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
        
        // 2) Coin Container
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
            make.top.equalTo(backButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        bonusGrid.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(claimButton.snp.top).offset(-30)
        }
        
        claimButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(56)
        }
        
        // Reward view constraints (same position as collection)
        rewardContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.82)
            make.height.equalToSuperview().multipliedBy(0.47)
        }
        
        rewardChestImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        rewardTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardChestImage.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        rewardDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rewardTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        rewardAmountContainer.snp.makeConstraints { make in
            make.top.equalTo(rewardDescriptionLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        rewardIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        rewardAmountLabel.snp.makeConstraints { make in
            make.leading.equalTo(rewardIcon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        bonusGrid.delegate = self
        bonusGrid.dataSource = self
        bonusGrid.register(DailyBonusCell.self, forCellWithReuseIdentifier: "DailyBonusCell")
    }
    
    // MARK: - Data Management
    private func loadDailyBonusData() {
        let lastClaimDate = UserDefaults.standard.object(forKey: "LastDailyBonusDate") as? Date
        let savedDay = UserDefaults.standard.integer(forKey: "CurrentDailyBonusDay")
        let claimed = UserDefaults.standard.bool(forKey: "HasClaimedDailyBonus")
        
        let calendar = Calendar.current
        let today = Date()
        
        if let lastDate = lastClaimDate {
            if calendar.isDate(lastDate, inSameDayAs: today) {
                hasClaimed = claimed
                currentDay = savedDay
                if hasClaimed {
                    startCountdown()
                }
            } else if calendar.dateInterval(of: .day, for: lastDate)?.end ?? Date() < today {
                hasClaimed = false
                if calendar.dateInterval(of: .day, for: lastDate)?.end ?? Date() < calendar.date(byAdding: .day, value: -1, to: today) ?? Date() {
                    currentDay = 1
                    clearDay7Cache()
                } else {
                    currentDay = savedDay < 7 ? savedDay + 1 : 1
                    if currentDay == 1 {
                        clearDay7Cache()
                    }
                }
            }
        } else {
            currentDay = 1
            hasClaimed = false
        }
        if currentDay == 7 {
            generateDay7Bonus()
        }
        
        UserDefaults.standard.set(currentDay, forKey: "CurrentDailyBonusDay")
    }
    
    private func generateDay7Bonus() {
        if let cachedDay7 = loadCachedDay7Bonus() {
            day7Bonus = cachedDay7
            return
        }
        
        let randomBonusType = availableBonusTypes.randomElement()!
        let baseAmount = getBaseAmountForBonusType(randomBonusType)
        day7Bonus = DailyBonus(day: 7, type: randomBonusType, amount: baseAmount)
        
        cacheDay7Bonus(day7Bonus!)
        print("🎰 Generated random Day 7 bonus: \(randomBonusType) x2 = \(baseAmount * 2)")
    }
    
    private func getBaseAmountForBonusType(_ type: DailyBonus.BonusType) -> Int {
        switch type {
        case .coins: return 500
        case .crystals: return 5
        case .infiniteLife15: return 15
        case .infiniteLife30: return 30
        case .timeBonus5: return 5
        case .timeBonus10: return 10
        case .megaReward: return 1000
        }
    }
    
    private func loadCachedDay7Bonus() -> DailyBonus? {
        guard let data = UserDefaults.standard.data(forKey: "CachedDay7Bonus"),
              let cachedBonus = try? JSONDecoder().decode(CachedDay7Bonus.self, from: data) else {
            return nil
        }
        
        return DailyBonus(day: 7, type: cachedBonus.type, amount: cachedBonus.amount)
    }
    
    private func cacheDay7Bonus(_ bonus: DailyBonus) {
        let cachedBonus = CachedDay7Bonus(type: bonus.type, amount: bonus.amount)
        if let data = try? JSONEncoder().encode(cachedBonus) {
            UserDefaults.standard.set(data, forKey: "CachedDay7Bonus")
        }
    }
    
    private func clearDay7Cache() {
        UserDefaults.standard.removeObject(forKey: "CachedDay7Bonus")
        day7Bonus = nil
    }
    
    private func getCurrentBonus(for day: Int) -> DailyBonus {
        if day == 7, let day7Bonus = day7Bonus {
            return day7Bonus
        }
        return dailyBonuses[day - 1]
    }
    
    private func updateUI() {
        coinLabel.text = "\(UserDataService.shared.coins)"
        crystalLabel.text = "\(UserDataService.shared.crystals)"
        
        if hasClaimed {
            claimButton.isEnabled = false
            startCountdown()
        } else {
            claimButton.isEnabled = true
            claimButton.backgroundColor = UIColor(hex: "#A77BCA")
            claimButton.setTitle("Claim", for: .normal)
        }
        
        bonusGrid.reloadData()
    }
    
    private func startCountdown() {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let startOfTomorrow = calendar.startOfDay(for: tomorrow)
        timeRemaining = startOfTomorrow.timeIntervalSince(Date())
        
        claimButton.isEnabled = false
        let total = Int(timeRemaining)
        let hours   = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        let initialTitle = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        UIView.performWithoutAnimation {
            claimButton.setTitle(initialTitle, for: .disabled)
            claimButton.layoutIfNeeded()
        }
        
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    
    private func updateCountdown() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            countdownTimer?.invalidate()
            hasClaimed = false
            UserDefaults.standard.set(false, forKey: "HasClaimedDailyBonus")
            updateUI()
            return
        }
        
        let t = format(timeRemaining)
        UIView.performWithoutAnimation {
            claimButton.setTitle(t, for: .disabled)
            claimButton.layoutIfNeeded()
        }
    }
    
    private func format(_ seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func claimButtonTapped() {
        if isShowingReward {
            claimDailyBonus()
            hideRewardView()
        } else {
            guard !hasClaimed else { return }
            showRewardView()
        }
    }
    
    private func showRewardView() {
        isShowingReward = true
        let bonus = getCurrentBonus(for: currentDay)
        
        // Setup reward content
        switch bonus.type {
        case .coins:
            rewardIcon.image = UIImage(named: "gold-coin")
            rewardAmountLabel.text = "\(bonus.finalAmount)"
        case .crystals:
            rewardIcon.image = UIImage(named: "diam-coin")
            rewardAmountLabel.text = "\(bonus.finalAmount)"
        case .infiniteLife15, .infiniteLife30:
            rewardIcon.image = UIImage(named: "Flame")
            rewardAmountLabel.text = "\(bonus.finalAmount)m"
        case .timeBonus5, .timeBonus10:
            rewardIcon.image = UIImage(named: "clock.fill")
            rewardAmountLabel.text = "+\(bonus.finalAmount)m"
        case .megaReward:
            rewardIcon.image = UIImage(named: "mega_reward_icon")
            rewardAmountLabel.text = "MEGA"
        }
        
        // Update title for day 7
        if currentDay == 7 {
            rewardTitleLabel.text = "MEGA BONUS x2!"
            rewardDescriptionLabel.text = "Your streak reward is doubled!"
        } else {
            rewardTitleLabel.text = "Daily Bonus Unlocked!"
            rewardDescriptionLabel.text = "Claim your reward now and keep the streak going!"
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bonusGrid.alpha = 0
        }) { _ in
            self.rewardContainer.alpha = 0
            self.rewardContainer.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.rewardContainer.alpha = 1
            }
        }
    }
    
    private func hideRewardView() {
        isShowingReward = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.rewardContainer.alpha = 0
        }) { _ in
            self.rewardContainer.isHidden = true
            
            self.hasClaimed = true
            UserDefaults.standard.set(true, forKey: "HasClaimedDailyBonus")
            self.bonusGrid.reloadData()
            
            self.updateUI()
            UIView.animate(withDuration: 0.3) {
                self.bonusGrid.alpha = 1
                self.claimButton.alpha = 1
            }
        }
    }
    
    private func claimDailyBonus() {
        let bonus = getCurrentBonus(for: currentDay)
        
        switch bonus.type {
        case .coins:
            UserDataService.shared.addCoins(bonus.finalAmount)
            showBonusAnimation(type: .coins, amount: bonus.finalAmount)
            
        case .crystals:
            UserDataService.shared.addCrystals(bonus.finalAmount)
            showBonusAnimation(type: .crystals, amount: bonus.finalAmount)
            
        case .infiniteLife15, .infiniteLife30:
            UserDataService.shared.activateInfiniteLife(minutes: bonus.finalAmount)
            showBonusAnimation(type: .infiniteLife, amount: bonus.finalAmount)
            
        case .timeBonus5, .timeBonus10:
            UserDataService.shared.addTimeBonus(minutes: bonus.finalAmount)
            showBonusAnimation(type: .timeBonus, amount: bonus.finalAmount)
            
        case .megaReward:
            // This case shouldn't happen anymore since day 7 is random
            break
        }
        
        hasClaimed = true
        UserDefaults.standard.set(true, forKey: "HasClaimedDailyBonus")
        UserDefaults.standard.set(Date(), forKey: "LastDailyBonusDate")
        
        updateTopBarValues()
        
        if currentDay == 7 {
            clearDay7Cache()
        }
    }
    
    // MARK: - Bonus Animation
    private func showBonusAnimation(type: BonusAnimationType, amount: Int) {
        switch type {
        case .coins:
            animateCoinsIncrease(amount: amount)
        case .crystals:
            animateCrystalsIncrease(amount: amount)
        case .infiniteLife:
            showInfiniteLifeNotification(minutes: amount)
        case .timeBonus:
            showTimeBonusNotification(minutes: amount)
        case .megaReward:
            showMegaRewardAnimation()
        }
    }
    
    private func animateCoinsIncrease(amount: Int) {
        let startValue = UserDataService.shared.coins - amount
        let endValue = UserDataService.shared.coins
        
        // Animate counter
        animateCounterChange(
            label: coinLabel,
            from: startValue,
            to: endValue,
            duration: 1.0
        )
        
        // Flying coins animation
        createFlyingCoinsAnimation(amount: amount)
    }
    
    private func animateCrystalsIncrease(amount: Int) {
        let startValue = UserDataService.shared.crystals - amount
        let endValue = UserDataService.shared.crystals
        
        // Animate counter
        animateCounterChange(
            label: crystalLabel,
            from: startValue,
            to: endValue,
            duration: 1.0
        )
        
        // Flying crystals animation
        createFlyingCrystalsAnimation(amount: amount)
    }
    
    private func animateCounterChange(label: UILabel, from startValue: Int, to endValue: Int, duration: TimeInterval) {
        let animation = CADisplayLink(target: self, selector: #selector(updateCounterAnimation))
        animation.add(to: .main, forMode: .default)
        
        // Store animation data
        counterAnimationData = CounterAnimationData(
            label: label,
            startValue: startValue,
            endValue: endValue,
            startTime: CACurrentMediaTime(),
            duration: duration,
            displayLink: animation
        )
    }
    
    @objc private func updateCounterAnimation() {
        guard let data = counterAnimationData else { return }
        
        let elapsed = CACurrentMediaTime() - data.startTime
        let progress = min(elapsed / data.duration, 1.0)
        
        let currentValue = data.startValue + Int(Double(data.endValue - data.startValue) * progress)
        data.label.text = "\(currentValue)"
        
        if progress >= 1.0 {
            data.displayLink.invalidate()
            counterAnimationData = nil
        }
    }
    
    private func createFlyingCoinsAnimation(amount: Int) {
        let coinCount = min(amount / 100 + 1, 5) // 1-5 flying coins based on amount
        
        for i in 0..<coinCount {
            let coinView = UIImageView(image: UIImage(named: "coin_icon"))
            coinView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            coinView.center = rewardAmountContainer.center
            view.addSubview(coinView)
            
            let delay = Double(i) * 0.1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                    coinView.center = self.coinContainer.center
                    coinView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                }) { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        coinView.alpha = 0
                        self.coinContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }) { _ in
                        coinView.removeFromSuperview()
                        UIView.animate(withDuration: 0.2) {
                            self.coinContainer.transform = .identity
                        }
                    }
                }
            }
        }
    }
    
    private func createFlyingCrystalsAnimation(amount: Int) {
        let crystalCount = min(amount, 3) // 1-3 flying crystals
        
        for i in 0..<crystalCount {
            let crystalView = UIImageView(image: UIImage(named: "crystal_icon"))
            crystalView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            crystalView.center = rewardAmountContainer.center
            view.addSubview(crystalView)
            
            let delay = Double(i) * 0.15
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                    crystalView.center = self.crystalContainer.center
                    crystalView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                }) { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        crystalView.alpha = 0
                        self.crystalContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }) { _ in
                        crystalView.removeFromSuperview()
                        UIView.animate(withDuration: 0.2) {
                            self.crystalContainer.transform = .identity
                        }
                    }
                }
            }
        }
    }
    
    private func showTimeBonusNotification(minutes: Int) {
        let multipliedMinutes = currentDay == 7 ? minutes : minutes
        let title = currentDay == 7 ? "MEGA Time Bonus!" : "Time Bonus Added!"
        let description = currentDay == 7 ? "+\(multipliedMinutes) minutes (x2 bonus!)" : "+\(multipliedMinutes) minutes to game timers"
        
        let notification = createBonusNotification(
            icon: UIImage(systemName: "clock.fill")!,
            title: title,
            description: description,
            color: .systemBlue
        )
        
        showNotification(notification)
    }
    
    private func showInfiniteLifeNotification(minutes: Int) {
        let multipliedMinutes = currentDay == 7 ? minutes : minutes
        let title = currentDay == 7 ? "MEGA Infinite Life!" : "Infinite Life Activated!"
        let description = currentDay == 7 ? "\(multipliedMinutes) minutes (x2 bonus!)" : "\(multipliedMinutes) minutes of unlimited lives"
        
        let notification = createBonusNotification(
            icon: UIImage(systemName: "heart.fill")!,
            title: title,
            description: description,
            color: .systemRed
        )
        
        showNotification(notification)
    }
    
    private func showMegaRewardAnimation() {
        // This method is no longer used since day 7 is now a random doubled bonus
        // Individual bonus animations are handled in their respective methods
    }
    
    private func createBonusNotification(icon: UIImage, title: String, description: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = color.cgColor
        
        let iconView = UIImageView(image: icon)
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 2
        
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(descLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return container
    }
    
    private func showNotification(_ notification: UIView) {
        view.addSubview(notification)
        
        notification.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.width.equalTo(280)
        }
        
        notification.alpha = 0
        notification.transform = CGAffineTransform(translationX: 0, y: -50)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            notification.alpha = 1
            notification.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, animations: {
                notification.alpha = 0
                notification.transform = CGAffineTransform(translationX: 0, y: -50)
            }) { _ in
                notification.removeFromSuperview()
            }
        }
    }
    
    private func updateTopBarValues() {
        // Animate the top bar values update
        UIView.transition(with: coinLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.coinLabel.text = "\(UserDataService.shared.coins)"
        }
        
        UIView.transition(with: crystalLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.crystalLabel.text = "\(UserDataService.shared.crystals)"
        }
    }
    
    
}

// MARK: - Collection View
extension DailyBonusViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private enum Layout {
        static let columnSpacing: CGFloat = 10
        static let rowSpacing: CGFloat = 24
        static let columns: CGFloat = 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyBonuses.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell   = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DailyBonusCell",
            for: indexPath) as! DailyBonusCell
        
        let day = indexPath.item + 1
        let bonus = getCurrentBonus(for: day)
        let isCompleted = day < currentDay || (day == currentDay && hasClaimed)
        let isCurrentDay = indexPath.item + 1 == currentDay
        
        cell.configure(with: bonus,
                       isCurrentDay: isCurrentDay,
                       isCompleted: isCompleted)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsInRow: CGFloat = indexPath.item == 6 ? 1 : Layout.columns
        
        let totalSpacing = Layout.columnSpacing * (itemsInRow - 1)
        let width  = (collectionView.bounds.width - totalSpacing) / itemsInRow
        let height = indexPath.item == 6 ? width * 0.5 : width
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Layout.columnSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Layout.rowSpacing
    }
}
