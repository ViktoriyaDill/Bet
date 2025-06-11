//
//  SpinWheelViewController.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import UIKit
import SnapKit


class SpinWheelViewController: BaseViewController {
    
    // MARK: - Properties
    private let backgroundImageView = UIImageView()
    
    private var coinLabel = UILabel()
    private var coinContainer = UIView()
    private var crystalLabel = UILabel()
    private var crystalContainer = UIView()
    
    private var hasClaimedFreeSpinToday = false
    private var countdownTimer: Timer?
    private var timeRemaining: TimeInterval = 0
    private var isShowingReward = false
    
    // Animation data
    private var counterAnimationData: CounterAnimationData?
    
    private let paidCost = 400
    private let wheelRewards: [WheelReward] = [
        .plusTimer5,    // 12:00 - 1:30
        .crystals5,     // 1:30 - 3:00
        .infiniteLife15, // 3:00 - 4:30
        .plusTimer5b,   // 4:30 - 6:00
        .freeSpin,      // 6:00 - 7:30
        .x2Boost5m,     // 7:30 - 9:00
        .infiniteLife30, // 9:00 - 10:30
        .coins500       // 10:30 - 12:00
    ]
    
    private var lastReward: WheelReward?
    
    // MARK: - Supporting Types
    enum BonusAnimationType {
        case coins
        case crystals
        case infiniteLife
        case timeBonus
        case freeSpin
        case boost
    }
    
    struct CounterAnimationData {
        let label: UILabel
        let startValue: Int
        let endValue: Int
        let startTime: CFTimeInterval
        let duration: TimeInterval
        let displayLink: CADisplayLink
    }
    
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
        label.text = "Spin Wheel"
        label.font = UIFont.sigmarOne(20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let pointerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wheel_pointer")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let wheelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Spin")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // Reward modal
    private let rewardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#4E4A8D")
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.isHidden = true
        return view
    }()
    
    private let rewardWheel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "color-spin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rewardTitle: UILabel = {
        let label = UILabel()
        label.text = "Congratulations!"
        label.font = UIFont.sigmarOne(16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let rewardDesc: UILabel = {
        let label = UILabel()
        label.text = "The wheel has stopped, and you've won!"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
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
        get { UserDefaults.standard.object(forKey: "SpinWheelEndDate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "SpinWheelEndDate") }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createHeaderView()
        setupConstraints()
        loadSpinWheelData()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countdownTimer?.invalidate()
        counterAnimationData?.displayLink.invalidate()
    }
    
    deinit {
        countdownTimer?.invalidate()
        counterAnimationData?.displayLink.invalidate()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerView)
        view.addSubview(titleLabel)
        view.addSubview(wheelImageView)
        view.addSubview(pointerImageView)
        view.addSubview(claimButton)
        
        view.addSubview(rewardContainer)
        rewardContainer.addSubview(rewardWheel)
        rewardContainer.addSubview(rewardTitle)
        rewardContainer.addSubview(rewardDesc)
        rewardContainer.addSubview(rewardAmountContainer)
        rewardAmountContainer.addSubview(rewardIcon)
        rewardAmountContainer.addSubview(rewardAmountLabel)
        view.addSubview(claimButton)
        
        backgroundImageView.image = UIImage(named: "spinBonusBG")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        // Actions
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        claimButton.addTarget(self, action: #selector(claimButtonTapped), for: .touchUpInside)
    }
    
    private func createHeaderView() {
        headerView.addSubview(backButton)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
            make.top.equalTo(backButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        wheelImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.height.equalTo(300)
        }
        
        pointerImageView.snp.makeConstraints { make in
            make.centerX.equalTo(wheelImageView)
            make.bottom.equalTo(wheelImageView.snp.top).offset(20)
            make.width.height.equalTo(40)
        }
        
        // Reward container constraints
        rewardContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.82)
            make.height.equalToSuperview().multipliedBy(0.47)
        }
        
        rewardWheel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        rewardTitle.snp.makeConstraints { make in
            make.top.equalTo(rewardWheel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        rewardDesc.snp.makeConstraints { make in
            make.top.equalTo(rewardTitle.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        rewardAmountContainer.snp.makeConstraints { make in
            make.top.equalTo(rewardDesc.snp.bottom).offset(40)
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
        
        claimButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(56)
        }
    }

    // MARK: - Data Management
    private func loadSpinWheelData() {
        let lastSpinDate = UserDefaults.standard.object(forKey: "LastSpinWheelDate") as? Date
        let claimed = UserDefaults.standard.bool(forKey: "HasClaimedFreeSpinToday")
        
        let calendar = Calendar.current
        let today = Date()
        
        if let lastDate = lastSpinDate {
            if calendar.isDate(lastDate, inSameDayAs: today) {
                hasClaimedFreeSpinToday = claimed
                if hasClaimedFreeSpinToday {
                    startCountdown()
                }
            } else if calendar.dateInterval(of: .day, for: lastDate)?.end ?? Date() < today {
                hasClaimedFreeSpinToday = false
                UserDefaults.standard.set(false, forKey: "HasClaimedFreeSpinToday")
            }
        } else {
            hasClaimedFreeSpinToday = false
        }
    }
    
    private func updateUI() {
        coinLabel.text    = "\(UserDataService.shared.coins)"
            crystalLabel.text = "\(UserDataService.shared.crystals)"
            guard !isShowingReward else { return }

            if !hasClaimedFreeSpinToday {
                claimButton.isEnabled = true
                claimButton.setTitle("Spin", for: .normal)
                return
            }

            let canPay = UserDataService.shared.coins >= paidCost
            claimButton.isEnabled = canPay

            let att = NSMutableAttributedString()
            let attach = NSTextAttachment()
            attach.image = UIImage(named: "gold-coin")?.withRenderingMode(.alwaysOriginal)
            attach.bounds = CGRect(x: 0, y: -3, width: 20, height: 20)
            att.append(NSAttributedString(attachment: attach))
            att.append(NSAttributedString(string: " \(paidCost)",
                attributes: [.foregroundColor: UIColor.white,
                             .font: UIFont.boldSystemFont(ofSize: 20)]))
            claimButton.setAttributedTitle(att, for: .normal)
    }
    
    private func startCountdown() {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let startOfTomorrow = calendar.startOfDay(for: tomorrow)
        timeRemaining = startOfTomorrow.timeIntervalSince(Date())
        countdownEndDate = startOfTomorrow
        
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        guard let end = countdownEndDate else { return }

            if Date() >= end {
                
                countdownTimer?.invalidate()
                countdownEndDate = nil
                hasClaimedFreeSpinToday = false
                UserDefaults.standard.set(false, forKey: "HasClaimedFreeSpinToday")
                updateUI()
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
            claimReward()
            hideRewardView()
            return
        }
        if !hasClaimedFreeSpinToday {
            performSpin(isPaid: false)
            return
        }
        
            if UserDataService.shared.coins < paidCost {
                showAlert(title: "Not enough coins",
                          message: "You need \(paidCost) coins to spin again.")
                return
            }
            _ = UserDataService.shared.spendCoins(paidCost)
            updateTopBarValues()
            performSpin(isPaid: true)
    }
    
    private func performSpin(isPaid: Bool = false) {
        claimButton.isEnabled = false

        let sectorCount = wheelRewards.count
        let sectorAngle = 2 * .pi / Double(sectorCount)
        let randomSector = Int.random(in: 0..<sectorCount)
        let finalAngle = Double.random(in: 4...6) * 2 * .pi + Double(randomSector) * sectorAngle

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            self.lastReward = self.wheelRewards[randomSector]
            self.showRewardView()
            if !self.hasClaimedFreeSpinToday {
                self.hasClaimedFreeSpinToday = true
                UserDefaults.standard.set(true,  forKey: "HasClaimedFreeSpinToday")
                UserDefaults.standard.set(Date(), forKey: "LastSpinWheelDate")
                self.startCountdown()
            }
            self.claimButton.isEnabled = true
        }

        let spin = CABasicAnimation(keyPath: "transform.rotation.z")
        spin.fromValue = 0
        spin.toValue = finalAngle
        spin.duration = 2
        spin.timingFunction = CAMediaTimingFunction(name: .easeOut)
        spin.fillMode = .forwards
        spin.isRemovedOnCompletion = false

        wheelImageView.layer.add(spin, forKey: "spin")
        CATransaction.commit()
    }

    
    private func showRewardView() {
        guard let reward = lastReward else { return }
        
        isShowingReward = true
        rewardTitle.text = reward.title
        rewardDesc.text = reward.description
        
        switch reward {
        case .coins500:
            rewardIcon.image = UIImage(named: "gold-coin")
            rewardAmountLabel.text = "500"
        case .crystals5:
            rewardIcon.image = UIImage(named: "diam-coin")
            rewardAmountLabel.text = "5"
        case .infiniteLife15:
            rewardIcon.image = UIImage(named: "Flame")
            rewardAmountLabel.text = "15m"
        case .infiniteLife30:
            rewardIcon.image = UIImage(named: "Flame")
            rewardAmountLabel.text = "30m"
        case .plusTimer5, .plusTimer5b:
            rewardIcon.image = UIImage(named: "Clock")
            rewardAmountLabel.text = "+5m"
        case .freeSpin:
            rewardIcon.image = UIImage(named: "color_wheel")
            rewardAmountLabel.text = "FREE"
        case .x2Boost5m:
            rewardIcon.image = UIImage(named: "x2Bonus")
            rewardAmountLabel.text = "2x"
        }
        
        claimButton.setTitle("Claim", for: .normal)
        claimButton.isEnabled = true
        
        rewardContainer.alpha = 0
        rewardContainer.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.rewardContainer.alpha = 1
        }
    }
    
    private func hideRewardView() {
        isShowingReward = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.rewardContainer.alpha = 0
        }) { _ in
            self.rewardContainer.isHidden = true
            self.updateUI()
        }
    }
    
    private func claimReward() {
        guard let reward = lastReward else { return }
        
        switch reward {
        case .coins500:
            UserDataService.shared.addCoins(500)
            showRewardAnimation(type: .coins, amount: 500)
            
        case .crystals5:
            UserDataService.shared.addCrystals(5)
            showRewardAnimation(type: .crystals, amount: 5)
            
        case .infiniteLife15:
            UserDataService.shared.activateInfiniteLife(minutes: 15)
            showRewardAnimation(type: .infiniteLife, amount: 15)
            
        case .infiniteLife30:
            UserDataService.shared.activateInfiniteLife(minutes: 30)
            showRewardAnimation(type: .infiniteLife, amount: 30)
            
        case .plusTimer5, .plusTimer5b:
            UserDataService.shared.addTimeBonus(minutes: 5)
            showRewardAnimation(type: .timeBonus, amount: 5)
            
        case .freeSpin:
            hasClaimedFreeSpinToday = false
            UserDefaults.standard.set(false, forKey: "HasClaimedFreeSpinToday")
            countdownTimer?.invalidate()
            timeRemaining = 0
            showRewardAnimation(type: .freeSpin, amount: 1)
            
        case .x2Boost5m:
            UserDataService.shared.activate2xBoost(minutes: 5)
            showRewardAnimation(type: .boost, amount: 5)
        }
        
        updateTopBarValues()
    }

    // MARK: - Reward Logic
    private func determineReward(from angle: Double) -> WheelReward {
        let normalizedAngle = angle.truncatingRemainder(dividingBy: 2 * Double.pi)
        
        let sectorAngle = 2 * Double.pi / 8
        let adjustedAngle = (normalizedAngle + sectorAngle / 2).truncatingRemainder(dividingBy: 2 * Double.pi)
        let sectorIndex = Int(adjustedAngle / sectorAngle)
        return wheelRewards[sectorIndex]
    }

    // MARK: - Animations
    private func showRewardAnimation(type: BonusAnimationType, amount: Int) {
        switch type {
        case .coins:
            animateCoinsIncrease(amount: amount)
        case .crystals:
            animateCrystalsIncrease(amount: amount)
        case .infiniteLife:
            showInfiniteLifeNotification(minutes: amount)
        case .timeBonus:
            showTimeBonusNotification(minutes: amount)
        case .freeSpin:
            showFreeSpinNotification()
        case .boost:
            showBoostNotification(minutes: amount)
        }
    }
    
    private func animateCoinsIncrease(amount: Int) {
        let startValue = UserDataService.shared.coins - amount
        let endValue = UserDataService.shared.coins
        
        animateCounterChange(
            label: coinLabel,
            from: startValue,
            to: endValue,
            duration: 1.0
        )
        
        createFlyingCoinsAnimation(amount: amount)
    }
    
    private func animateCrystalsIncrease(amount: Int) {
        let startValue = UserDataService.shared.crystals - amount
        let endValue = UserDataService.shared.crystals
        
        animateCounterChange(
            label: crystalLabel,
            from: startValue,
            to: endValue,
            duration: 1.0
        )
        
        createFlyingCrystalsAnimation(amount: amount)
    }
    
    private func animateCounterChange(label: UILabel, from startValue: Int, to endValue: Int, duration: TimeInterval) {
        let animation = CADisplayLink(target: self, selector: #selector(updateCounterAnimation))
        animation.add(to: .main, forMode: .default)
        
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
        let coinCount = min(amount / 100 + 1, 5)
        
        for i in 0..<coinCount {
            let coinView = UIImageView(image: UIImage(named: "gold-coin"))
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
        let crystalCount = min(amount, 3)
        
        for i in 0..<crystalCount {
            let crystalView = UIImageView(image: UIImage(named: "diam-coin"))
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
        let notification = createBonusNotification(
            icon: UIImage(systemName: "clock.fill")!,
            title: "Time Bonus Added!",
            description: "+\(minutes) minutes to game timers",
            color: .systemBlue
        )
        
        showNotification(notification)
    }
    
    private func showInfiniteLifeNotification(minutes: Int) {
        let notification = createBonusNotification(
            icon: UIImage(systemName: "heart.fill")!,
            title: "Infinite Life Activated!",
            description: "\(minutes) minutes of unlimited lives",
            color: .systemRed
        )
        
        showNotification(notification)
    }
    
    private func showFreeSpinNotification() {
        let notification = createBonusNotification(
            icon: UIImage(named: "color-spin")!,
            title: "Free Spin Unlocked!",
            description: "You can spin again for free!",
            color: .systemGreen
        )
        
        showNotification(notification)
    }
    
    private func showBoostNotification(minutes: Int) {
        let notification = createBonusNotification(
            icon: UIImage(systemName: "bolt.fill")!,
            title: "2x Boost Activated!",
            description: "All bonuses doubled for \(minutes) minutes",
            color: .systemOrange
        )
        
        showNotification(notification)
    }
    
    private func createBonusNotification(icon: UIImage, title: String, description: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(hex: "#4E4A8D")
        container.layer.cornerRadius = 8
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
        UIView.transition(with: coinLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.coinLabel.text = "\(UserDataService.shared.coins)"
        }
        
        UIView.transition(with: crystalLabel, duration: 0.3, options: .transitionCrossDissolve) {
            self.crystalLabel.text = "\(UserDataService.shared.crystals)"
        }
    }
    
    // MARK: - Helper
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
