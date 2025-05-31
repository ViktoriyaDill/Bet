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
    
    private let gameAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange
        view.layer.cornerRadius = 8
        return view
    }()
    
    private var bubbleViews: [UIView] = []
    private var gameDisplayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbleCatchUI()
        setupBubbleCatchConstraints()
        setupBubbleCatchGestures()
        bindViewModel()
    }
    
    private func setupBubbleCatchUI() {
        view.addSubview(gameAreaView)
        gameAreaView.addSubview(basketView)
    }
    
    private func setupBubbleCatchConstraints() {
        gameAreaView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(startButton.snp.top).offset(-20)
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
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    @objc private func basketPanned(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gameAreaView)
        viewModel.moveBasket(to: viewModel.basketPosition + translation.x)
        
        basketView.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(viewModel.basketPosition)
        }
        
        gesture.setTranslation(.zero, in: gameAreaView)
    }
    
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
    
    private func updateBubbleViews() {
        // Remove excess bubble views
        while bubbleViews.count > viewModel.bubbles.count {
            let bubbleView = bubbleViews.removeLast()
            bubbleView.removeFromSuperview()
        }
        
        // Add new bubble views
        while bubbleViews.count < viewModel.bubbles.count {
            let bubbleView = UIView()
            bubbleView.layer.cornerRadius = 15
            bubbleView.backgroundColor = .systemBlue
            gameAreaView.addSubview(bubbleView)
            bubbleViews.append(bubbleView)
        }
        
        // Update positions and colors
        for (index, bubble) in viewModel.bubbles.enumerated() {
            let bubbleView = bubbleViews[index]
            bubbleView.backgroundColor = bubble.color
            bubbleView.frame = CGRect(x: bubble.position.x, y: bubble.position.y, width: 30, height: 30)
        }
    }
    
    override func startButtonTapped() {
        super.startButtonTapped()
        viewModel.startGame()
        startButton.setTitle("Game Active", for: .normal)
        startButton.backgroundColor = .systemGray
        startButton.isEnabled = false
        startGameLoop()
    }
}

extension BubbleCatchGameViewController: GameViewModelDelegate {
    func gameDidStart() {
        bubbleViews.forEach { $0.removeFromSuperview() }
        bubbleViews.removeAll()
        
        basketView.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(0)
        }
    }
    
    func gameDidEnd(score: Int) {
        startButton.setTitle("Start Game", for: .normal)
        startButton.backgroundColor = .systemGreen
        startButton.isEnabled = true
        stopGameLoop()
        
        let alert = UIAlertController(title: "Game Over", message: "Bubbles Caught: \(score / 10)\nFinal Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func scoreDidUpdate(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}
