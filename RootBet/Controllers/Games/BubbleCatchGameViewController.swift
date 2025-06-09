//
//  BubbleCatchGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

class BubbleCatchGameViewController: BaseGameViewController {
    
    private let viewModel = BubbleCatchViewModel()
    
    // MARK: - Game State
    enum GameState {
        case ready, playing, gameOver
    }
    
    private var gameState: GameState = .ready
    
    // MARK: - UI Elements
    private let gameAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#8346BC")
        view.layer.cornerRadius = 8
        return view
    }()
    
    // MARK: - Game Objects
    private var bubbleViews: [UIView] = []
    private var gameDisplayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameType = .bubbleCatch
        
        setupBubbleCatchUI()
        setupBubbleCatchConstraints()
        setupBubbleCatchGestures()
        bindViewModel()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewModel.updateGameArea(
            width: gameAreaView.bounds.width,
            height: gameAreaView.bounds.height
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGameLoop()
        viewModel.endGame()
    }
    
    // MARK: - UI Setup
    private func setupBubbleCatchUI() {
        view.addSubview(gameAreaView)
        gameAreaView.addSubview(basketView)
    }
    
    private func setupBubbleCatchConstraints() {
        gameAreaView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(playButton.snp.top).offset(-20)
        }
        
        basketView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    private func setupBubbleCatchGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(basketPanned(_:)))
        basketView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(basketTapped(_:)))
        basketView.addGestureRecognizer(tapGesture)
        
        let gameAreaTapGesture = UITapGestureRecognizer(target: self, action: #selector(gameAreaTapped(_:)))
        gameAreaView.addGestureRecognizer(gameAreaTapGesture)
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Gesture Handlers
    @objc private func basketPanned(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gameAreaView)
        viewModel.moveBasket(to: viewModel.basketPosition + translation.x)
        updateBasketPosition()
        gesture.setTranslation(.zero, in: gameAreaView)
    }
    
    @objc private func basketTapped(_ gesture: UITapGestureRecognizer) {
        viewModel.toggleBasketType()
        updateBasketColor()
        HapticManager.shared.lightTap()
    }
    
    @objc private func gameAreaTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: gameAreaView)
        let gameAreaCenter = gameAreaView.bounds.width / 2
        let targetPosition = location.x - gameAreaCenter
        
        viewModel.moveBasket(to: targetPosition)
        
        UIView.animate(withDuration: 0.2) {
            self.updateBasketPosition()
        }
    }
    
    private func updateBasketPosition() {
        basketView.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(viewModel.basketPosition)
        }
        view.layoutIfNeeded()
    }
    
    private func updateBasketColor() {
        UIView.animate(withDuration: 0.2) {
            self.basketView.backgroundColor = self.viewModel.currentBasketType.color
        }
    }
    
    // MARK: - Game Loop
    private func startGameLoop() {
        gameDisplayLink = CADisplayLink(target: self, selector: #selector(updateGame))
        gameDisplayLink?.add(to: .main, forMode: .default)
    }
    
    private func stopGameLoop() {
        gameDisplayLink?.invalidate()
        gameDisplayLink = nil
    }
    
    @objc private func updateGame() {
        updateBubbleViews()
    }
    
    // MARK: - Bubble Rendering
    private func updateBubbleViews() {
        let activeBubbles = viewModel.bubbles.filter { $0.isActive }
        
        // Remove excess bubble views
        while bubbleViews.count > activeBubbles.count {
            let bubbleView = bubbleViews.removeLast()
            bubbleView.removeFromSuperview()
        }
        
        // Add new bubble views
        while bubbleViews.count < activeBubbles.count {
            let bubbleView = createBubbleView()
            gameAreaView.insertSubview(bubbleView, belowSubview: basketView)
            bubbleViews.append(bubbleView)
        }
        
        // Update positions and colors
        for (index, bubble) in activeBubbles.enumerated() {
            guard index < bubbleViews.count else { break }
            
            let bubbleView = bubbleViews[index]
            updateBubbleView(bubbleView, with: bubble)
        }
    }
    
    private func createBubbleView() -> UIView {
        let bubbleView = UIView()
        bubbleView.layer.cornerRadius = 15
        return bubbleView
    }
    
    private func updateBubbleView(_ bubbleView: UIView, with bubble: BubbleCatchViewModel.Bubble) {
        bubbleView.frame = CGRect(
            x: bubble.position.x - bubble.size/2,
            y: bubble.position.y - bubble.size/2,
            width: bubble.size,
            height: bubble.size
        )
        
        bubbleView.backgroundColor = bubble.color
        bubbleView.layer.cornerRadius = bubble.size / 2
    }
    
    // MARK: - Game Control
    override func playButtonTapped() {
        super.playButtonTapped()
        
        switch gameState {
        case .ready:
            startGame()
        case .playing:
            pauseGame()
        case .gameOver:
            resetGame()
        }
    }
    
    private func startGame() {
        gameState = .playing
        playButton.setTitle("Pause", for: .normal)
        playButton.backgroundColor = .systemGray
        
        viewModel.startGame()
        startGameLoop()
    }
    
    private func pauseGame() {
        gameState = .ready
        playButton.setTitle("Resume", for: .normal)
        playButton.backgroundColor = UIColor(hex: "#A77BCA")
        
        viewModel.pauseGame()
        stopGameLoop()
    }
    
    private func resetGame() {
        gameState = .ready
        stopGameLoop()
        
        // Clear bubble views
        bubbleViews.forEach { $0.removeFromSuperview() }
        bubbleViews.removeAll()
        
        // Reset basket
        viewModel.moveBasket(to: 0)
        updateBasketPosition()
        basketView.backgroundColor = UIColor(hex: "#8346BC")
        
        // Reset UI
        playButton.setTitle("Start Game", for: .normal)
        playButton.backgroundColor = UIColor(hex: "#A77BCA")
        updateUI()
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        coinsLabel.text = "\(UserDataService.shared.coins)"
    }
    
    private func updateScore(_ score: Int) {
        scoreLabel.text = "\(score)"
    }
    
    private func updateLives(_ lives: Int) {
        roundLabel.text = "\(lives)"
    }
    
    private func updateTime(_ seconds: Int) {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func showGameOverAlert() {
        let alert = UIAlertController(
            title: "Game Over!",
            message: "Final Score: \(scoreLabel.text ?? "0")",
            preferredStyle: .alert
        )
        
        let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.resetGame()
        }
        
        let homeAction = UIAlertAction(title: "Home", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(playAgainAction)
        alert.addAction(homeAction)
        
        present(alert, animated: true)
    }
    
    deinit {
        stopGameLoop()
    }
}

// MARK: - GameViewModelDelegate
extension BubbleCatchGameViewController: GameViewModelDelegate {
    
    func gameDidStart() {
        resetGame()
        gameState = .playing
        HapticManager.shared.lightTap()
    }
    
    func gameDidEnd(score: Int) {
        gameState = .gameOver
        stopGameLoop()
        
        // Add coins based on score
        let coinsEarned = score / 10
        if coinsEarned > 0 {
            UserDataService.shared.addCoins(coinsEarned)
        }
        
        updateUI()
        
        playButton.setTitle("Try Again", for: .normal)
        playButton.backgroundColor = UIColor(hex: "#A77BCA")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showGameOverAlert()
        }
        
        HapticManager.shared.error()
    }
    
    func scoreDidUpdate(_ score: Int) {
        updateScore(score)
        HapticManager.shared.lightTap()
    }
    
    func livesDidUpdate(_ lives: Int) {
        updateLives(lives)
        
        if lives > 0 {
            HapticManager.shared.mediumTap()
        }
    }
    
    func timeDidUpdate(_ time: Int) {
        updateTime(time)
    }
}
