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
    
    private let basket1View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#8346BC")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let basket2View: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#5722A1")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    // MARK: - Game Objects
    private var bubbleViews: [UIView] = []
    private var gameDisplayLink: CADisplayLink?
    
    // Tracking touch for baskets
    private var activeTouchBasket1: UITouch?
    private var activeTouchBasket2: UITouch?
    
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
        guard gameAreaView.bounds.width > 0 && gameAreaView.bounds.height > 0 else { return }
        
        viewModel.updateGameArea(
            width: gameAreaView.bounds.width,
            height: gameAreaView.bounds.height
        )
        if gameState != .playing {
            setupInitialBasketPositions()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGameLoop()
        viewModel.endGame()
    }
    
    // MARK: - UI Setup
    private func setupBubbleCatchUI() {
        view.addSubview(gameAreaView)
        gameAreaView.addSubview(basket1View)
        gameAreaView.addSubview(basket2View)
    }
    
    private func setupBubbleCatchConstraints() {
        gameAreaView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(playButton.snp.top).offset(-20)
        }
        
        basket1View.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(160)
            make.height.equalTo(48)
            make.centerX.equalToSuperview().multipliedBy(0.5)
        }
        
        basket2View.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(160)
            make.height.equalTo(48)
            make.centerX.equalToSuperview().multipliedBy(1.5)
        }
    }
    
    private func setupBubbleCatchGestures() {
        gameAreaView.isMultipleTouchEnabled = true
        gameAreaView.isUserInteractionEnabled = true
        basket1View.isUserInteractionEnabled = true
        basket2View.isUserInteractionEnabled = true
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Touch Handling for Baskets
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .playing else {
              print("❌ Touch ignored - game not playing")
              return
          }
          
          for touch in touches {
              let location = touch.location(in: gameAreaView)
              print("👆 Touch began at: \(location)")
              
              if basket1View.frame.contains(location) && activeTouchBasket1 == nil {
                  activeTouchBasket1 = touch
                  print("🏀 Basket1 touched!")
                  HapticManager.shared.lightTap()
              }
              else if basket2View.frame.contains(location) && activeTouchBasket2 == nil {
                  activeTouchBasket2 = touch
                  print("🏀 Basket2 touched!")
                  HapticManager.shared.lightTap()
              }
          }
    }
    
    // MARK: - Touch Handling
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameState == .playing else { return }
        for touch in touches {
            let loc = touch.location(in: gameAreaView)
            if touch == activeTouchBasket1 {
                viewModel.moveBasket1(to: loc.x)
                basket1View.center.x = loc.x
            } else if touch == activeTouchBasket2 {
                viewModel.moveBasket2(to: loc.x)
                basket2View.center.x = loc.x
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == activeTouchBasket1 {
                activeTouchBasket1 = nil
            } else if touch == activeTouchBasket2 {
                activeTouchBasket2 = nil
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: - Basket Position Updates
    private func updateBasketPositions() {
        updateBasket1PositionSmooth()
        updateBasket2PositionSmooth()
    }
    
    private func setupInitialBasketPositions() {
        let gameAreaWidth = gameAreaView.bounds.width
        let gameAreaHeight = gameAreaView.bounds.height
        
        let basket1X = gameAreaWidth * 0.25
        let basket2X = gameAreaWidth * 0.75
        let basketsY = gameAreaHeight - 20 - basket1View.bounds.height/2
        
        basket1View.center = CGPoint(x: basket1X, y: basketsY)
        basket2View.center = CGPoint(x: basket2X, y: basketsY)
        
        viewModel.moveBasket1(to: basket1X)
        viewModel.moveBasket2(to: basket2X)
        
        print("🏀 Initial baskets positioned - Basket1: \(basket1X), Basket2: \(basket2X), GameArea width: \(gameAreaWidth)")
    }
    
    private func updateBasket1Position() {
        let basket = viewModel.basket1
        let gameAreaCenter = gameAreaView.bounds.width / 2
        let offsetFromCenter = basket.x - gameAreaCenter
        
        basket1View.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(offsetFromCenter)
        }
        view.layoutIfNeeded()
    }
    
    private func updateBasket2Position() {
        let basket = viewModel.basket2
        let gameAreaCenter = gameAreaView.bounds.width / 2
        let offsetFromCenter = basket.x - gameAreaCenter
        
        basket2View.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(offsetFromCenter)
        }
        view.layoutIfNeeded()
    }
    
    private func updateBasket1PositionSmooth() {
        let basket = viewModel.basket1
        let gameAreaCenter = gameAreaView.bounds.width / 2
        let offsetFromCenter = basket.x - gameAreaCenter
        let newFrame = CGRect(
            x: basket.x - basket.width/2,
            y: basket2View.frame.origin.y,
            width: basket.width,
            height: basket.height
        )
        
        basket1View.frame = newFrame
    }
    
    private func updateBasket2PositionSmooth() {
        let basket = viewModel.basket2
        let gameAreaCenter = gameAreaView.bounds.width / 2
        let offsetFromCenter = basket.x - gameAreaCenter
        let newFrame = CGRect(
            x: basket.x - basket.width/2,
            y: basket2View.frame.origin.y,
            width: basket.width,
            height: basket.height
        )
        
        basket2View.frame = newFrame
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
            gameAreaView.insertSubview(bubbleView, belowSubview: basket1View)
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
        bubbleView.layer.cornerRadius = 34
        bubbleView.layer.borderWidth = 1
        bubbleView.layer.borderColor = UIColor.white.cgColor
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
        viewModel.startGame()
        startGameLoop()
    }
    
    
    private func pauseGame() {
        gameState = .ready
        playButton.isHidden = false
        
        gameAreaView.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(playButton.snp.top).offset(-20)
        }
        view.layoutIfNeeded()
        
        viewModel.pauseGame()
        stopGameLoop()
    }
    
    private func resetGame() {
        gameState = .ready
        stopGameLoop()
        
        // Clear bubble views
        bubbleViews.forEach { $0.removeFromSuperview() }
        bubbleViews.removeAll()
        
        playButton.isHidden = false
        gameAreaView.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(playButton.snp.top).offset(-20)
        }
        view.layoutIfNeeded()
        
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
    
    private func showGameResult(score: Int, isNewRecord: Bool) {
        let resultType: ResultType = .lost
        
        let winLoseVC = WinLoseViewController()
        winLoseVC.gameType = .bubbleCatch
        winLoseVC.resultType = resultType
        winLoseVC.score = "\(score)"
        winLoseVC.isNewRecord = isNewRecord
        winLoseVC.delegate = self
        
        winLoseVC.modalPresentationStyle = .fullScreen
        present(winLoseVC, animated: true)
    }
    
    private func isNewRecord(score: Int) -> Bool {
        let bestScore = UserDefaults.standard.integer(forKey: "BubbleCatchBestScore")
        return score > bestScore
    }
    
    private func saveBestScore(_ score: Int) {
        let bestScore = UserDefaults.standard.integer(forKey: "BubbleCatchBestScore")
        if score > bestScore {
            UserDefaults.standard.set(score, forKey: "BubbleCatchBestScore")
            UserDefaults.standard.synchronize()
        }
    }
    
    deinit {
        stopGameLoop()
    }
}

// MARK: - GameViewModelDelegate
extension BubbleCatchGameViewController: GameViewModelDelegate {
    
    func gameDidStart() {
        gameState = .playing
        playButton.isHidden = true
        gameAreaView.snp.remakeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        view.layoutIfNeeded()
        
        bubbleViews.forEach { $0.removeFromSuperview() }
        bubbleViews.removeAll()
        
        HapticManager.shared.lightTap()
    }
    
    func gameDidEnd(score: Int) {
        gameState = .gameOver
        stopGameLoop()
        
        // Save best score first
        saveBestScore(score)
        let isRecord = isNewRecord(score: score)
        
        // Add coins based on score
        let coinsEarned = score / 10
        if coinsEarned > 0 {
            UserDataService.shared.addCoins(coinsEarned)
        }
        
        updateUI()
        
        playButton.setTitle("Try Again", for: .normal)
        playButton.backgroundColor = UIColor(hex: "#A77BCA")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.showGameResult(score: score, isNewRecord: isRecord)
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

// MARK: - WinLoseDegateProtocol

extension BubbleCatchGameViewController: WinLoseDegateProtocol {
    func tryAgainTapped() {
        dismiss(animated: false) { [weak self] in
            self?.resetGame()
        }
    }
    
    func homeTapped() {
        dismiss(animated: false) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func claimTapped() {
        dismiss(animated: false) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: false)
        }
    }
}
