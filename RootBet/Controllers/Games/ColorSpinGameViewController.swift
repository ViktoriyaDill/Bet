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
        UIColor(hex: "#FF9500") // orange
    ]
    
    private var targetColor: UIColor = UIColor(hex: "#9C80FF")
    private var currentRound = 3 // Починаємо з 3 і віднімаємо
    private var totalRounds = 3
    private var finalColorIndex = 0
    private var gameScore = 0
    private var spinsCompleted = 0
    
    // MARK: - Game States
    private enum GameState {
        case ready      // Готовий до спіну
        case spinning   // Колесо крутиться
        case stopping   // Колесо зупиняється
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
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("⚠️ Audio file not found: \(fileName).mp3")
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
        
        // Обчислюємо фінальний кут та індекс кольору під стрілкою
        let randomAngle = CGFloat.random(in: 0...(CGFloat.pi * 2))
        
        // Стрілка знаходиться зверху (0 градусів)
        let normalizedAngle = randomAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
        let sectionAngle = (CGFloat.pi * 2) / CGFloat(gameColors.count)
        
        // Індекс кольору під стрілкою
        finalColorIndex = Int(normalizedAngle / sectionAngle) % gameColors.count
        
        // Анімація плавного зупинення
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
            playWinSound()
        } else {
            // Перевіримо сусідні кольори для часткової винагороди
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
        
        // Короткий показ результату раунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.proceedToNextRound()
        }
    }
    
    private func proceedToNextRound() {
        currentRound -= 1
        
        if currentRound > 0 {
            // Ще є раунди
            gameState = .ready
            generateTargetColor()
            updatePlayButton()
            wheelImageView.layer.removeAllAnimations()
            stopAllSounds()
        } else {
            // Гра закінчена
            endGame()
        }
    }
    
    private func endGame() {
        stopAllSounds()
        
        let resultType: ResultType = (gameScore > 0) ? .win : .lost
        
        if gameScore > 0 {
            UserDataService.shared.addCoins(gameScore)
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
        stopAllSounds()
    }
}

extension ColorSpinGameViewController: GameViewModelDelegate {
    
    func infoButtoTapped() {
        print("infoButtoTapped")
    }
    
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


