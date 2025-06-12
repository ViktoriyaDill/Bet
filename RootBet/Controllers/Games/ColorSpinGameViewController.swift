//
//  ColorSpinGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

class ColorSpinGameViewController: BaseGameViewController {
    
    private let viewModel = ColorSpinViewModel()
    private let userService = UserDataService.shared
    private var gameState: GameState = .ready
    
    // MARK: - Audio Players
    private var wheelSpinPlayer: AVAudioPlayer?
    private var wheelStopPlayer: AVAudioPlayer?
    private var winSoundPlayer: AVAudioPlayer?
    private var loseSoundPlayer: AVAudioPlayer?
    
    // MARK: - Game State
    private var gameColors: [UIColor] = [
        UIColor(hex: "#9C80FF"), // purple
        UIColor(hex: "#FFCC00"), // yellow
        UIColor(hex: "#6C0080"), // dark purple
        UIColor(hex: "#FF2D55"), // pink
        UIColor(hex: "#34C759"), // green
        UIColor(hex: "#FF9500"),// orange
        UIColor(hex: "#9C80FF"),
        UIColor(hex: "#FFCC00"),
        UIColor(hex: "#6C0080"),
        UIColor(hex: "#FF2D55"),
        UIColor(hex: "#34C759"),
        UIColor(hex: "#FF9500"),
        UIColor(hex: "#9C80FF"),
        UIColor(hex: "#FFCC00"),
        UIColor(hex: "#6C0080"),
        UIColor(hex: "#FF2D55"),
        UIColor(hex: "#34C759"),
        UIColor(hex: "#FF9500")
    ]
    
    private var targetColor: UIColor = UIColor(hex: "#9C80FF")
    private var currentRound = 3
    private var totalRounds = 3
    private var finalColorIndex = 0
    private var gameScore = 0
    private var spinsCompleted = 0
    
    // MARK: - Game States
    private enum GameState {
        case ready
        case spinning
        case stopping
    }
    
    // MARK: - UI Elements
    private let wheelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "color_wheel")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let pointerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wheel_pointer")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let targetColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorSpinUI()
        setupColorSpinConstraints()
        bindViewModel()
        setupAudioPlayers()
        startNewGame()
        
        setupBonusNotifications()
        setupAchievementTracking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let coinsCount = userService.coins
        coinsLabel.text = "\(coinsCount)"
    }
    
    private func setupColorSpinUI() {
        view.addSubview(wheelImageView)
        view.addSubview(pointerImageView)
        view.addSubview(targetColorView)
    }
    
    private func setupColorSpinConstraints() {
        wheelImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(wheelImageView.snp.width)
        }
        
        pointerImageView.snp.makeConstraints { make in
            make.centerX.equalTo(wheelImageView)
            make.bottom.equalTo(wheelImageView.snp.top).offset(20)
            make.width.height.equalTo(40)
        }
        
        targetColorView.snp.makeConstraints { make in
            make.bottom.equalTo(pointerImageView.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Audio Setup
    private func setupAudioPlayers() {
        setupAudioPlayer(fileName: "wheel_spin", player: &wheelSpinPlayer)
        setupAudioPlayer(fileName: "wheel_stop", player: &wheelStopPlayer)
        setupAudioPlayer(fileName: "win_sound", player: &winSoundPlayer)
        setupAudioPlayer(fileName: "lose_sound", player: &loseSoundPlayer)
        
        wheelSpinPlayer?.numberOfLoops = -1
    }
    
    private func setupAudioPlayer(fileName: String, player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else {
            print("⚠️ Audio file not found: \(fileName).wav")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 0.7
        } catch {
            print("❌ Error creating audio player for \(fileName): \(error)")
        }
    }
    
    // MARK: - Game Logic
    private func startNewGame() {
        currentRound = 3
        spinsCompleted = 0
        gameScore = 0
        gameState = .ready
        generateTargetColor()
        updatePlayButton()
    }
    
    private func generateTargetColor() {
        targetColor = gameColors.randomElement() ?? UIColor(hex: "#9C80FF")
        targetColorView.backgroundColor = targetColor
        updateRoundLabel()
    }
    
    private func updateRoundLabel() {
        roundLabel.text = "\(currentRound)/\(totalRounds)"
    }
    
    private func updatePlayButton() {
        switch gameState {
        case .ready:
            playButton.setTitle("Play", for: .normal)
            playButton.backgroundColor = UIColor.systemPurple
            
        case .spinning:
            playButton.setTitle("Spin", for: .normal)
            playButton.backgroundColor = UIColor.systemPurple
            
        case .stopping:
            playButton.setTitle("Stop", for: .normal)
            playButton.backgroundColor = UIColor.systemPurple
        }
    }
    
    override func playButtonTapped() {
        super.playButtonTapped()
        HapticManager.shared.mediumTap()
        
        switch gameState {
        case .ready:
            // Перехід до режиму спіну
            gameState = .spinning
            updatePlayButton()
            
        case .spinning:
            // Запуск обертання колеса
            gameState = .stopping
            updatePlayButton()
            startWheelRotation()
            playWheelSpinSound()
            
        case .stopping:
            // Зупинка колеса
            stopWheelRotation()
            stopWheelSpinSound()
            playWheelStopSound()
        }
    }
    
    // MARK: - Wheel Animation
    private func startWheelRotation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 0.2
        rotation.repeatCount = .infinity
        wheelImageView.layer.add(rotation, forKey: "spinRotation")
    }
    
    private func stopWheelRotation() {
        wheelImageView.layer.removeAllAnimations()
        let randomAngle = CGFloat.random(in: 0...(CGFloat.pi * 2))
        let normalizedAngle = randomAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
        let sectionAngle = (CGFloat.pi * 2) / CGFloat(gameColors.count)
        finalColorIndex = Int(normalizedAngle / sectionAngle) % gameColors.count
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = wheelImageView.layer.presentation()?.value(forKeyPath: "transform.rotation") ?? 0
        rotation.toValue = randomAngle
        rotation.duration = 1.5
        rotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.handleSpinResult()
        }
        wheelImageView.layer.add(rotation, forKey: "stopRotation")
        CATransaction.commit()
    }
    
    private func handleSpinResult() {
        let selectedColor = gameColors[finalColorIndex]
        let isWin = selectedColor.isEqual(targetColor)
        
        spinsCompleted += 1
        
        var roundReward = 0
        if isWin {
            roundReward = 100
            trackWin()
            playWinSound()
        } else {
            if let targetIndex = gameColors.firstIndex(where: { $0.isEqual(targetColor) }) {
                let distance = abs(finalColorIndex - targetIndex)
                let wrapDistance = min(distance, gameColors.count - distance)
                if wrapDistance == 1 {
                    roundReward = 50
                }
            }
            playLoseSound()
        }
        
        gameScore += roundReward
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.proceedToNextRound()
        }
    }
    
    private func proceedToNextRound() {
        currentRound -= 1
        
        if currentRound > 0 {
            gameState = .ready
            generateTargetColor()
            updatePlayButton()
            wheelImageView.layer.removeAllAnimations()
            stopAllSounds()
        } else {
            endGame()
        }
    }
    
    private func endGame() {
        stopAllSounds()
        trackGamePlayed()
        trackHighScore()
        updateDailyChallenges()
        
        let resultType: ResultType = (gameScore > 0) ? .win : .lost
        
        if gameScore > 0 {
            let finalCoins = applyBonuses(to: gameScore)
            UserDataService.shared.addCoins(finalCoins)
        }
        
        let winLoseVC = WinLoseViewController()
        winLoseVC.gameType = .colorSpin
        winLoseVC.resultType = resultType
        winLoseVC.score = "\(gameScore)"
        winLoseVC.isNewRecord = (gameScore > 0)
        winLoseVC.delegate = self
        
        winLoseVC.modalPresentationStyle = .fullScreen
        present(winLoseVC, animated: true, completion: nil)
    }
    
    private func trackWin() {
        let wins = UserDefaults.standard.integer(forKey: "ColorSpinWins")
        UserDefaults.standard.set(wins + 1, forKey: "ColorSpinWins")
        
        AchievementsViewController.updateAchievementProgress(type: .winColorSpinRounds, progress: wins + 1)
        AchievementsViewController.updateAchievementProgress(type: .highScoreColorSpin, progress: gameScore)
    }
    
    // MARK: - Audio Control
    private func playWheelSpinSound() {
        wheelSpinPlayer?.currentTime = 0
        wheelSpinPlayer?.play()
    }
    
    private func playWheelStopSound() {
        wheelStopPlayer?.currentTime = 0
        wheelStopPlayer?.play()
    }
    
    private func playWinSound() {
        winSoundPlayer?.currentTime = 0
        winSoundPlayer?.play()
    }
    
    private func playLoseSound() {
        loseSoundPlayer?.currentTime = 0
        loseSoundPlayer?.play()
    }
    
    private func stopWheelSpinSound() {
        wheelSpinPlayer?.stop()
    }
    
    private func stopAllSounds() {
        wheelSpinPlayer?.stop()
        wheelStopPlayer?.stop()
        winSoundPlayer?.stop()
        loseSoundPlayer?.stop()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopAllSounds()
    }
}

// MARK: - Bonus & Achievement Methods
extension ColorSpinGameViewController {
    
    private func setupBonusNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bonusActivated),
            name: .infiniteLifeActivated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bonusActivated),
            name: .timeBonusAdded,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bonusActivated),
            name: .boost2xActivated,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bonusActivated),
            name: .doubleRewardActivated,
            object: nil
        )
    }

    @objc private func bonusActivated(_ notification: Notification) {
        HapticManager.shared.success()
    }

    private func setupAchievementTracking() {
        AchievementsViewController.updateAchievementProgress(type: .playFirstGame, progress: 1)
        AchievementsViewController.updateAchievementProgress(type: .playColorSpinRounds, progress: 1)
    }
    
    private func applyBonuses(to coins: Int) -> Int {
        var result = coins
        
        if UserDataService.shared.has2xBoost {
            result *= 2
        }
        
        if UserDataService.shared.hasDoubleReward {
            result *= 2
        }
        
        return result
    }

    // MARK: - Achievement Tracking
    
    private func trackHighScore() {
        AchievementsViewController.updateAchievementProgress(type: .highScoreColorSpin, progress: gameScore)
    }

    private func trackGamePlayed() {
        let gamesPlayed = UserDefaults.standard.integer(forKey: "ColorSpinGamesPlayed")
        UserDefaults.standard.set(gamesPlayed + 1, forKey: "ColorSpinGamesPlayed")
        
        AchievementsViewController.updateAchievementProgress(type: .playColorSpinRounds, progress: gamesPlayed + 1)
        checkVersatilePlayer()
    }

    private func checkVersatilePlayer() {
        let colorSpinPlayed = UserDefaults.standard.integer(forKey: "ColorSpinGamesPlayed") > 0
        let stackTowerPlayed = UserDefaults.standard.integer(forKey: "StackTowerGamesPlayed") > 0
        let bubbleCatchPlayed = UserDefaults.standard.integer(forKey: "BubbleCatchGamesPlayed") > 0
        let memoryMatchPlayed = UserDefaults.standard.integer(forKey: "MemoryMatchGamesPlayed") > 0
        
        let gamesPlayedCount = [colorSpinPlayed, stackTowerPlayed, bubbleCatchPlayed, memoryMatchPlayed].filter { $0 }.count
        
        AchievementsViewController.updateAchievementProgress(type: .playAllGames, progress: gamesPlayedCount)
    }

    // MARK: - Daily Challenge Integration
    private func updateDailyChallenges() {
        let progress: [String: Any] = [
            "correctStreak": spinsCompleted,
            "score": gameScore,
            "bonusHits": gameScore / 100
        ]
    }
}

extension ColorSpinGameViewController: GameViewModelDelegate {
    func livesDidUpdate(_ lives: Int) {}
    
    func timeDidUpdate(_ time: Int) {}
    

    func gameDidStart() {
        startNewGame()
    }
    
    func gameDidEnd(score: Int) {
        endGame()
    }
    
    func scoreDidUpdate(_ score: Int) {}
}

// MARK: - WinLoseDegateProtocol
extension ColorSpinGameViewController: WinLoseDegateProtocol {
    func tryAgainTapped() {
        dismiss(animated: true) { [weak self] in
            self?.startNewGame()
        }
    }
    
    func homeTapped() {
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func claimTapped() {
        dismiss(animated: true) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
