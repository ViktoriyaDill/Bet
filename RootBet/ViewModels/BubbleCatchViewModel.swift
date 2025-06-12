//
//  BubbleCatchViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit

class BubbleCatchViewModel {
    weak var delegate: GameViewModelDelegate?
    
    // MARK: - Game State
    private var isGameActive = false
    private var gameTimer: Timer?
    private var bubbleSpawnTimer: Timer?
    private var bubbleUpdateTimer: Timer?
    private var timeTimer: Timer?

    // MARK: - Game Properties
    var currentScore = 0
    private var livesRemaining = 3
    private var gameTime = 0
    private var gameSpeed: CGFloat = 1.0
    private var consecutiveCatchCount = 0

    // MARK: - Bubble Properties
    private var bubbleSpawnRate: TimeInterval = 1.5
    private var bubbleFallSpeed: CGFloat = 2.0
    private var maxBubbles = 6

    // MARK: - Game Area
    var gameAreaWidth: CGFloat = 335
    var gameAreaHeight: CGFloat = 600

    // MARK: - Basket Properties
    struct BasketPosition {
        var x: CGFloat
        var y: CGFloat
        let width: CGFloat = 80
        let height: CGFloat = 40
        let type: BubbleType
        
        var rect: CGRect {
            return CGRect(x: x - width/2, y: y - height/2, width: width, height: height)
        }
    }
    
    private(set) var basket1: BasketPosition
    private(set) var basket2: BasketPosition

    // MARK: - Bubble Types
    enum BubbleType: CaseIterable {
        case purple1  // #8346BC
        case purple2  // #5722A1

        var color: UIColor {
            switch self {
            case .purple1: return UIColor(hex: "#8346BC")
            case .purple2: return UIColor(hex: "#5722A1")
            }
        }

        var points: Int { return 10 }
    }

    // MARK: - Bubble Model
    struct Bubble {
        let id = UUID()
        var position: CGPoint
        var velocity: CGFloat
        let type: BubbleType
        let size: CGFloat = 68
        var isActive: Bool = true

        var color: UIColor { type.color }

        mutating func updatePosition() {
            position.y += velocity
        }

        func isOffScreen(gameHeight: CGFloat) -> Bool {
            return position.y > gameHeight + size
        }

        func intersects(with basketRect: CGRect) -> Bool {
            let bubbleRect = CGRect(
                x: position.x - size/2,
                y: position.y - size/2,
                width: size,
                height: size
            )
            return bubbleRect.intersects(basketRect)
        }
    }

    // MARK: - Game Data
    private(set) var bubbles: [Bubble] = []

    // MARK: - Initialization
    init() {
        basket1 = BasketPosition(x: 100, y: 500, type: .purple1)
        basket2 = BasketPosition(x: 235, y: 500, type: .purple2)
    }

    // MARK: - Public Interface
    func updateGameArea(width: CGFloat, height: CGFloat) {
        gameAreaWidth = width
        gameAreaHeight = height
        
        let basketY = gameAreaHeight - 40
        basket1.x = gameAreaWidth * 0.25
        basket1.y = basketY
        
        basket2.x = gameAreaWidth * 0.75
        basket2.y = basketY
    }

    func moveBasket1(to position: CGFloat) {
        let halfWidth = basket1.width / 2
        let minX = -halfWidth
        let maxX = gameAreaWidth + halfWidth
        basket1.x = max(minX, min(maxX, position))
    }
    
    func moveBasket2(to position: CGFloat) {
        let halfWidth = basket2.width / 2
        let minX = -halfWidth
        let maxX = gameAreaWidth + halfWidth
        basket2.x = max(minX, min(maxX, position))
    }

    func startGame() {
        resetGameState()
        isGameActive = true

        delegate?.gameDidStart()
        delegate?.scoreDidUpdate(currentScore)
        delegate?.livesDidUpdate(livesRemaining)
        delegate?.timeDidUpdate(gameTime)

        startGameTimers()
    }

    func pauseGame() {
        isGameActive = false
        stopGameTimers()
    }

    func resumeGame() {
        guard !isGameActive else { return }
        isGameActive = true
        startGameTimers()
    }

    func endGame() {
        isGameActive = false
        stopGameTimers()
        bubbles.removeAll()
        delegate?.gameDidEnd(score: currentScore)
    }

    // MARK: - Private Methods

    private func resetGameState() {
        currentScore = 0
        livesRemaining = 3
        gameTime = 0
        gameSpeed = 1.0
        consecutiveCatchCount = 0
        bubbles.removeAll()
        bubbleSpawnRate = 1.5
        bubbleFallSpeed = 2.0
        maxBubbles = 6
    }

    private func startGameTimers() {
        // Game time timer
        timeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateGameTime()
        }

        // Bubble update timer (60 FPS)
        bubbleUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
            self?.updateGame()
        }

        // Bubble spawn timer
        scheduleNextBubbleSpawn()

        // Difficulty increase timer
        gameTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            self?.increaseGameDifficulty()
        }
    }

    private func stopGameTimers() {
        timeTimer?.invalidate()
        timeTimer = nil
        gameTimer?.invalidate()
        gameTimer = nil
        bubbleSpawnTimer?.invalidate()
        bubbleSpawnTimer = nil
        bubbleUpdateTimer?.invalidate()
        bubbleUpdateTimer = nil
    }

    private func updateGameTime() {
        gameTime += 1
        delegate?.timeDidUpdate(gameTime)
    }

    private func scheduleNextBubbleSpawn() {
        let spawnDelay = bubbleSpawnRate / Double(gameSpeed)
        bubbleSpawnTimer?.invalidate()
        bubbleSpawnTimer = Timer.scheduledTimer(withTimeInterval: spawnDelay, repeats: false) { [weak self] _ in
            self?.spawnBubble()
            self?.scheduleNextBubbleSpawn()
        }
    }

    private func updateGame() {
           guard isGameActive else { return }
           
           let basket1Rect = basket1.rect
           let basket2Rect = basket2.rect
           var indicesToRemove: [Int] = []
           
           for index in bubbles.indices {
               var bubble = bubbles[index]
               
               guard bubble.isActive else {
                   indicesToRemove.append(index)
                   continue
               }

               bubble.updatePosition()
               bubbles[index] = bubble

               var caught = false
               
               if bubble.intersects(with: basket1Rect) {
                   handleBubbleCatch(bubble, caughtBasketType: basket1.type)
                   indicesToRemove.append(index)
                   caught = true
               }
               else if bubble.intersects(with: basket2Rect) {
                   handleBubbleCatch(bubble, caughtBasketType: basket2.type)
                   indicesToRemove.append(index)
                   caught = true
               }

               if caught { continue }

               if bubble.isOffScreen(gameHeight: gameAreaHeight) {
                   loseLife()
                   indicesToRemove.append(index)
                   continue
               }
           }
           for index in indicesToRemove.reversed() {
               guard index < bubbles.count else { continue }
               bubbles.remove(at: index)
           }
       }

    private func handleBubbleCatch(_ bubble: Bubble, caughtBasketType: BubbleType) {
        let isCorrectBasket = bubble.type == caughtBasketType

        if isCorrectBasket {
            consecutiveCatchCount += 1
            let multiplier = min(consecutiveCatchCount, 5)
            let pointsToAdd = bubble.type.points * multiplier
            addScore(pointsToAdd)
            
            print("✅ Correct catch! \(bubble.type) bubble in \(caughtBasketType) basket. +\(pointsToAdd) points (x\(multiplier) multiplier)")
        } else {
            consecutiveCatchCount = 0
            loseLife()
            print("❌ Wrong basket! \(bubble.type) bubble in \(caughtBasketType) basket. Life lost.")
        }
    }

    private func spawnBubble() {
        guard isGameActive && bubbles.count < maxBubbles else { return }

        let bubbleType: BubbleType = Bool.random() ? .purple1 : .purple2
        let randomFactor = CGFloat.random(in: 0.8...1.2)
        
        let bubble = Bubble(
            position: CGPoint(
                x: CGFloat.random(in: 30...(gameAreaWidth - 30)),
                y: -30
            ),
            velocity: bubbleFallSpeed * gameSpeed * randomFactor,
            type: bubbleType
        )

        bubbles.append(bubble)
        print("🫧 Spawned \(bubbleType) bubble at x: \(bubble.position.x)")
    }

    private func addScore(_ points: Int) {
        currentScore += points
        delegate?.scoreDidUpdate(currentScore)
    }

    private func loseLife() {
        consecutiveCatchCount = 0
        livesRemaining = max(0, livesRemaining - 1)
        delegate?.livesDidUpdate(livesRemaining)

        if livesRemaining <= 0 {
            DispatchQueue.main.async { [weak self] in
                self?.endGame()
            }
        }
    }

    private func increaseGameDifficulty() {
        gameSpeed = min(2.0, gameSpeed + 0.15)
        bubbleSpawnRate = max(0.8, bubbleSpawnRate - 0.1)
        bubbleFallSpeed = min(3.5, bubbleFallSpeed + 0.2)
        maxBubbles = min(10, maxBubbles + 1)
        scheduleNextBubbleSpawn()
    }

    deinit {
        stopGameTimers()
    }
}
