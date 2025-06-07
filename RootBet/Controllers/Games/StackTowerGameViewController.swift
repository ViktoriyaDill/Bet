//
//  StackTowerGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

class StackTowerGameViewController: BaseGameViewController {
    
    private let viewModel = StackTowerViewModel()
    
    private var towerResets = 0
    private var extraSpeed: CGFloat { CGFloat(towerResets) * 0.5 }
    
    
    // MARK: - Audio Players
    private var blockDropPlayer: AVAudioPlayer?
    private var perfectAlignPlayer: AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?
    private var blockMovePlayer: AVAudioPlayer?
    
    // MARK: - Game Properties
    private var gameState: GameState = .ready
    private var currentLevel = 1
    private var gameScore = 0
    private var perfectAlignments = 0
    private var blockWidth: CGFloat = 120
    private var baseBlockWidth: CGFloat = 120
    private var movingTimer: Timer?
    private var gameTimer: Timer?
    private var gameTime = 0
    private var livesRemaining = 3
    private var bestScore = 0
    
    // MARK: - Game State
    private enum GameState {
        case ready
        case playing
        case gameOver
    }
    
    // MARK: - UI Elements
    private let gameAreaView = UIView()
    
    private lazy var dropTapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(dropButtonTapped)
    )
    
    
    
    // MARK: - Game Objects
    private var stackedBlocks: [UIView] = []
    private var currentMovingBlock: UIView?
    private var blockMovingDirection: CGFloat = 1.0
    private var blockMovingSpeed: CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameType = .stackTower
        
        setupStackTowerUI()
        setupStackTowerConstraints()
        setupAudioPlayers()
        bindViewModel()
        loadBestScore()
        resetGame()
        
        dropTapGesture.numberOfTapsRequired = 1
        gameAreaView.isUserInteractionEnabled = true
        gameAreaView.addGestureRecognizer(dropTapGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAllTimers()
        stopAllSounds()
    }
    
    // MARK: - UI Setup
    private func setupStackTowerUI() {
        view.addSubview(gameAreaView)
    }
    
    private func setupStackTowerConstraints() {
        gameAreaView.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(playButton.snp.top)
        }
    }
    
    
    // MARK: - Audio Setup
    private func setupAudioPlayers() {
        setupAudioPlayer(fileName: "block_drop", player: &blockDropPlayer)
        setupAudioPlayer(fileName: "perfect_align", player: &perfectAlignPlayer)
        setupAudioPlayer(fileName: "game_over", player: &gameOverPlayer)
        setupAudioPlayer(fileName: "block_move", player: &blockMovePlayer)
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
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Game Logic
    
    override func playButtonTapped() {
        super.playButtonTapped()
        HapticManager.shared.mediumTap()
        
        if gameState == .ready {
            startGame()
        }
    }
    
    @objc private func dropButtonTapped() {
        guard gameState == .playing, let movingBlock = currentMovingBlock else { return }
        
        HapticManager.shared.lightTap()
        stopBlockMovement()
        dropCurrentBlock()
    }
    
    private func startGame() {
        gameState = .playing
        gameScore = 0
        currentLevel = 1
        perfectAlignments = 0
        gameTime = 0
        blockWidth = baseBlockWidth
        livesRemaining = 3
        
        updateUI()
        updateButtons()
        createBaseBlock()
        startGameTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.createMovingBlock()
        }
    }
    
    private func resetGame() {
        gameState = .ready
        stopAllTimers()
        clearAllBlocks()
        
        gameScore = 0
        currentLevel = 1
        perfectAlignments = 0
        gameTime = 0
        blockWidth = baseBlockWidth
        livesRemaining = 3
        
        updateUI()
        setupStackTowerConstraints()
        updateButtons()
    }
    
    private func loseLife() {
        livesRemaining -= 1
        updateLivesDisplay()
        
        if livesRemaining <= 0 {
            endGame()
        } else {
            playGameOverSound()
            HapticManager.shared.error()
            blockWidth = baseBlockWidth
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.createMovingBlock()
            }
        }
    }
    
    // MARK: - Game End
    
    private func endGame() {
        gameState = .gameOver
        stopAllTimers()
        stopAllSounds()
        
        let isRecord = isNewRecord()
        saveBestScore()
        
        let coinReward = calculateCoinReward()
        if coinReward > 0 {
            UserDataService.shared.addCoins(coinReward)
        }
        
        updateUI()
        updateButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.showGameResult(isNewRecord: isRecord)
        }
    }
    
    // MARK: - Block Management
    
    private func createBaseBlock() {
        let baseBlock = createBlock(width: blockWidth, color: UIColor.systemPurple)
        gameAreaView.addSubview(baseBlock)
        
        baseBlock.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(blockWidth)
            make.height.equalTo(80)
        }
        gameAreaView.layoutIfNeeded()
        stackedBlocks.append(baseBlock)
    }
    
    private func createMovingBlock() {
        guard gameState == .playing else { return }
               
               currentMovingBlock?.removeFromSuperview()
               
               let movingBlock = createBlock(width: blockWidth, color: getBlockColor())
               gameAreaView.addSubview(movingBlock)
               currentMovingBlock = movingBlock
               
               let lastBlock = stackedBlocks.last!
               let newY = lastBlock.frame.origin.y - 105
               let centerX = gameAreaView.bounds.width / 2 - blockWidth / 2
               
               movingBlock.frame = CGRect(
                   x: centerX,
                   y: newY,
                   width: blockWidth,
                   height: 80
               )
               
        gameAreaView.layoutIfNeeded()
               startBlockMovement()
    }
    
    private func createBlock(width: CGFloat, color: UIColor) -> UIView {
        let block = UIView()
        block.backgroundColor = color
        block.layer.borderWidth = 1
        block.layer.borderColor = UIColor.white.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            color.cgColor,
            color.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.cornerRadius = 8
        block.layer.insertSublayer(gradientLayer, at: 0)
        
        DispatchQueue.main.async {
            gradientLayer.frame = block.bounds
        }
        
        return block
    }
    
    private func getBlockColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(hex: "#8346BC"), UIColor(hex: "#5722A1"), UIColor(hex: "#7B08D3")
        ]
        return colors[currentLevel % colors.count]
    }
    
    private func checkTowerHeight() {
        let towerHeight = CGFloat(stackedBlocks.count) * 85 + 60
        if towerHeight >= gameAreaView.bounds.height - 100 {
            resetTowerKeepingLastBlock()
        }
    }
    
    private func resetTowerKeepingLastBlock() {
        guard let lastBlock = stackedBlocks.last else { return }
        
        for block in stackedBlocks.dropLast() {
            block.removeFromSuperview()
        }
        stackedBlocks = [lastBlock]
        
        lastBlock.removeFromSuperview()
        gameAreaView.addSubview(lastBlock)
        lastBlock.translatesAutoresizingMaskIntoConstraints = false
        
        lastBlock.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(lastBlock.frame.width)
            make.height.equalTo(80)
        }
        lastBlock.layoutIfNeeded()
        gameAreaView.layoutIfNeeded()
        
        towerResets += 1
        currentLevel = 1
        perfectAlignments = 0
        gameScore += 200
        
        updateUI()
    }
    
    
    
    // MARK: - Block Movement
    
    private func startBlockMovement() {
        blockMovingSpeed = 2.0 + CGFloat(currentLevel) * 0.3 + extraSpeed
        
        movingTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateBlockPosition()
        }
    }
    
    private func stopBlockMovement() {
        movingTimer?.invalidate()
        movingTimer = nil
    }
    
    private func updateBlockPosition() {
        guard let movingBlock = currentMovingBlock else { return }
        
        let currentX = movingBlock.frame.origin.x
        let gameAreaWidth = gameAreaView.frame.width
        let blockCurrentWidth = movingBlock.frame.width
        let newX = currentX + (blockMovingDirection * blockMovingSpeed)
        
        let margin: CGFloat = blockCurrentWidth * 0.7
        
        if newX <= -margin {
            blockMovingDirection = 1.0
            movingBlock.frame.origin.x = -margin
        } else if newX + blockCurrentWidth >= gameAreaWidth + margin {
            blockMovingDirection = -1.0
            movingBlock.frame.origin.x = gameAreaWidth + margin - blockCurrentWidth
        } else {
            movingBlock.frame.origin.x = newX
        }
        
        if currentLevel == 1 {
            print("📍 Block x: \(movingBlock.frame.origin.x), direction: \(blockMovingDirection)")
        }
    }
    
    // MARK: - Block Dropping Logic
    
    private func dropCurrentBlock() {
        guard let movingBlock = currentMovingBlock else {
            return
        }
        
        guard let lastBlock = stackedBlocks.last else {
            return
        }
        
        let startY = movingBlock.frame.origin.y
        
        playBlockDropSound()
        
        let overlap = calculateOverlap(movingBlock: movingBlock, lastBlock: lastBlock)
        
        if overlap <= 5 {
            animateBlockFall(movingBlock)
            loseLife()
            return
        }
        
        let newWidth = overlap
        let alignment = calculateAlignment(movingBlock: movingBlock, lastBlock: lastBlock)
        
        if abs(alignment) < 5.0 && abs(newWidth - blockWidth) < 5.0 {
            perfectAlignments += 1
            gameScore += 100 + (currentLevel * 10)
            playPerfectAlignSound()
            HapticManager.shared.success()
            print("✨ Perfect alignment! Block keeps original size, but blockWidth updated to: \(newWidth)")
        } else {
            gameScore += 50 + (currentLevel * 5)
            HapticManager.shared.lightTap()
            print("📏 Block attached with original size, but blockWidth updated to: \(newWidth)")
        }
        blockWidth = newWidth

        updateDroppedBlockPosition(movingBlock, newWidth: newWidth, alignment: alignment)
        
        stackedBlocks.append(movingBlock)
        currentMovingBlock = nil
        
        gameAreaView.layoutIfNeeded()
        checkTowerHeight()
        
        if blockWidth < 30 {
            loseLife()
            return
        }
        
        currentLevel += 1
        updateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.createMovingBlock()
        }
    }
    
    private func calculateOverlap(movingBlock: UIView, lastBlock: UIView) -> CGFloat {
        let movingLeft = movingBlock.frame.origin.x
        let movingRight = movingLeft + movingBlock.frame.width
        let lastLeft = lastBlock.frame.origin.x
        let lastRight = lastLeft + lastBlock.frame.width
        
        let overlapLeft = max(movingLeft, lastLeft)
        let overlapRight = min(movingRight, lastRight)
        
        return max(0, overlapRight - overlapLeft)
    }
    
    private func calculateAlignment(movingBlock: UIView, lastBlock: UIView) -> CGFloat {
        let movingCenter = movingBlock.frame.origin.x + movingBlock.frame.width / 2
        let lastCenter = lastBlock.frame.origin.x + lastBlock.frame.width / 2
        return movingCenter - lastCenter
    }
    
    private func updateDroppedBlockPosition(_ block: UIView, newWidth: CGFloat, alignment: CGFloat) {
        let lastBlock = stackedBlocks.last!
        
        let lastCenter = lastBlock.frame.origin.x + lastBlock.frame.width / 2
        let blockCenter = newWidth / 2
        let newX = lastCenter - blockCenter
        
        let newY = lastBlock.frame.origin.y - 85
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            block.frame = CGRect(
                x: newX,
                y: newY,
                width: block.frame.width,
                height: 80
            )
        }
    }
    
    private func animateBlockFall(_ block: UIView) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn) {
            block.frame.origin.y += 500
            block.alpha = 0
        } completion: { _ in
            block.removeFromSuperview()
        }
    }
    
    
    
    // MARK: - Game Timer
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.gameTime += 1
            self?.updateUI()
        }
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        scoreLabel.text = "\(gameScore)"
        timeLabel.text = String(format: "%02d:%02d", gameTime / 60, gameTime % 60)
        roundLabel.text = "\(currentLevel)"
        coinsLabel.text = "\(UserDataService.shared.coins)"
        updateLivesDisplay()
    }
    
    private func updateLivesDisplay() {
        switch livesRemaining {
        case 3:
            roundLabel.text = "3"
        case 2:
            roundLabel.text = "2"
        case 1:
            roundLabel.text = "1"
        case 0:
            roundLabel.text = "0"
        default:
            roundLabel.text = "3"
        }
    }
    
    private func updateButtons() {
        switch gameState {
        case .ready:
            playButton.setTitle("Start Game", for: .normal)
            playButton.backgroundColor = UIColor(hex: "#A77BCA")
            playButton.isEnabled = true
            playButton.isHidden = false
            
        case .playing:
            playButton.isHidden = true
            gameAreaView.snp.remakeConstraints { make in
                make.top.equalTo(timeLabel.snp.bottom).offset(14)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-20)
            }
            
        case .gameOver:
            playButton.setTitle("Try Again", for: .normal)
            playButton.backgroundColor = UIColor(hex: "#A77BCA")
            playButton.isEnabled = true
            playButton.isHidden = true
        }
    }

    
    // MARK: - Score Management
    
    private func loadBestScore() {
        bestScore = UserDefaults.standard.integer(forKey: "StackTowerBestScore")
    }
    
    private func saveBestScore() {
        if gameScore > bestScore {
            bestScore = gameScore
            UserDefaults.standard.set(bestScore, forKey: "StackTowerBestScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func isNewRecord() -> Bool {
        return gameScore > UserDefaults.standard.integer(forKey: "StackTowerBestScore")
    }
    private func calculateCoinReward() -> Int {
        let baseReward = stackedBlocks.count * 10
        let perfectBonus = perfectAlignments * 20
        let levelBonus = currentLevel * 5
        return baseReward + perfectBonus + levelBonus
    }
    
    private func showGameResult(isNewRecord: Bool) {
        let resultType: ResultType = .lost
        
        let winLoseVC = WinLoseViewController()
        winLoseVC.gameType = .stackTower
        winLoseVC.resultType = resultType
        winLoseVC.score = "\(gameScore)"
        winLoseVC.isNewRecord = isNewRecord
        winLoseVC.delegate = self
        
        winLoseVC.modalPresentationStyle = .fullScreen
        present(winLoseVC, animated: true)
    }
    
    // MARK: - Cleanup
    private func clearAllBlocks() {
        stackedBlocks.forEach { $0.removeFromSuperview() }
        stackedBlocks.removeAll()
        currentMovingBlock?.removeFromSuperview()
        currentMovingBlock = nil
    }
    
    private func stopAllTimers() {
        movingTimer?.invalidate()
        movingTimer = nil
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    // MARK: - Audio Control
    private func playBlockDropSound() {
        blockDropPlayer?.currentTime = 0
        blockDropPlayer?.play()
    }
    
    private func playPerfectAlignSound() {
        perfectAlignPlayer?.currentTime = 0
        perfectAlignPlayer?.play()
    }
    
    private func playGameOverSound() {
        gameOverPlayer?.currentTime = 0
        gameOverPlayer?.play()
    }
    
    private func stopAllSounds() {
        blockDropPlayer?.stop()
        perfectAlignPlayer?.stop()
        gameOverPlayer?.stop()
        blockMovePlayer?.stop()
    }
    
    deinit {
        stopAllTimers()
        stopAllSounds()
    }
}

// MARK: - GameViewModelDelegate
extension StackTowerGameViewController: GameViewModelDelegate {
    
    func gameDidStart() {
        startGame()
    }
    
    func gameDidEnd(score: Int) {
        endGame()
    }
    
    func scoreDidUpdate(_ score: Int) {
        gameScore = score
        updateUI()
    }
}

// MARK: - WinLoseDegateProtocol
extension StackTowerGameViewController: WinLoseDegateProtocol {
    func tryAgainTapped() {
        dismiss(animated: false) { [weak self] in
            self?.gameState = .ready
            self?.resetGame()
        }
    }
    
    func homeTapped() {
        dismiss(animated: false) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func claimTapped() {}
}
