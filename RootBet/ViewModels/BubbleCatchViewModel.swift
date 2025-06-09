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
    private var currentScore = 0
    private var livesRemaining = 3
    private var gameTime = 0
    private var gameSpeed: CGFloat = 1.0
    // Track consecutive successful catches for multipliers
    private var consecutiveCatchCount = 0

    // MARK: - Bubble Properties
    private var bubbleSpawnRate: TimeInterval = 1.5
    private var bubbleFallSpeed: CGFloat = 2.0
    private var maxBubbles = 6

    // MARK: - Game Area
    var gameAreaWidth: CGFloat = 335
    var gameAreaHeight: CGFloat = 600

    // MARK: - Basket Properties
    var basketPosition: CGFloat = 0
    private let basketWidth: CGFloat = 80
    private let basketHeight: CGFloat = 40

    // MARK: - Bubble Types
    enum BubbleType: CaseIterable {
        case purple1  // #8346BC - catch in purple1 basket
        case purple2  // #5722A1 - catch in purple2 basket

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
        let size: CGFloat = 30
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

    // MARK: - Basket Model
    enum BasketType {
        case purple1, purple2

        var color: UIColor {
            switch self {
            case .purple1: return UIColor(hex: "#8346BC")
            case .purple2: return UIColor(hex: "#5722A1")
            }
        }
    }

    // MARK: - Game Data
    private(set) var bubbles: [Bubble] = []
    private(set) var currentBasketType: BasketType = .purple1

    // MARK: - Public Interface
    func updateGameArea(width: CGFloat, height: CGFloat) {
        gameAreaWidth = width
        gameAreaHeight = height
    }

    func moveBasket(to position: CGFloat) {
        let halfBasketWidth = basketWidth / 2
        let minX = -gameAreaWidth/2 + halfBasketWidth
        let maxX = gameAreaWidth/2 - halfBasketWidth

        basketPosition = max(minX, min(maxX, position))
    }

    func toggleBasketType() {
        currentBasketType = currentBasketType == .purple1 ? .purple2 : .purple1
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
        basketPosition = 0
        currentBasketType = .purple1
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
        // Define basket frame for collision detection
           let basketRect = CGRect(
               x: basketPosition - basketWidth/2,
               y: gameAreaHeight - basketHeight - 20,
               width: basketWidth,
               height: basketHeight
           )

           // Iterate backwards so we can remove bubbles safely
           for index in (0..<bubbles.count).reversed() {
               var bubble = bubbles[index]

               guard bubble.isActive else { continue }

               // Move bubble
               bubble.updatePosition()

               // Check for catch
               if bubble.intersects(with: basketRect) {
                   // Compare basket and bubble types for correctness
                   if (bubble.type == .purple1 && currentBasketType == .purple1) ||
                      (bubble.type == .purple2 && currentBasketType == .purple2) {
                       // Correct catch
                       consecutiveCatchCount += 1
                       let multiplier = consecutiveCatchCount
                       let pointsToAdd = bubble.type.points * multiplier
                       addScore(pointsToAdd)
                   } else {
                       // Wrong basket color
                       loseLife()
                   }
                   // Deactivate bubble
                   bubbles[index].isActive = false
                   continue
               }

               // Check if bubble fell past bottom
               if bubble.isOffScreen(gameHeight: gameAreaHeight) {
                   bubbles[index].isActive = false
                   loseLife()
                   continue
               }

               // Update the stored bubble (position change)
               bubbles[index] = bubble
           }

           // Remove any inactive bubbles
           removeInactiveBubbles()
    }

    private func updateBubbles() {
        // Safely iterate through the original bubble set and exit early if game ends
        let countAtStart = bubbles.count
        for i in 0..<countAtStart {
            // Stop if bubbles have been cleared (e.g., game ended)
            guard i < bubbles.count else { break }
            bubbles[i].updatePosition()
            if bubbles[i].isOffScreen(gameHeight: gameAreaHeight) {
                bubbles[i].isActive = false
                loseLife() // Lose life for any missed bubble
                // If the game just ended (bubbles removed), exit loop
                if !isGameActive {
                    return
                }
            }
        }
    }

    private func checkCollisions() {
        let basketRect = CGRect(
            x: basketPosition - basketWidth/2,
            y: gameAreaHeight - basketHeight - 20,
            width: basketWidth,
            height: basketHeight
        )

        for i in bubbles.indices {
            if bubbles[i].isActive && bubbles[i].intersects(with: basketRect) {
                handleBubbleCatch(bubbles[i])
                bubbles[i].isActive = false
            }
        }
    }

    private func handleBubbleCatch(_ bubble: Bubble) {
        let isCorrectBasket =
            (bubble.type == .purple1 && currentBasketType == .purple1) ||
            (bubble.type == .purple2 && currentBasketType == .purple2)

        if isCorrectBasket {
            // Increase streak and apply multiplier
            consecutiveCatchCount += 1
            let multiplier = consecutiveCatchCount
            let pointsToAdd = bubble.type.points * multiplier
            addScore(pointsToAdd)
        } else {
            loseLife()
        }
    }

    private func spawnBubble() {
        guard isGameActive && bubbles.filter({ $0.isActive }).count < maxBubbles else { return }

        let bubbleType: BubbleType = Bool.random() ? .purple1 : .purple2
        // Introduce variation in fall speed
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
    }

    private func removeInactiveBubbles() {
        bubbles.removeAll { !$0.isActive }
    }

    private func addScore(_ points: Int) {
        currentScore += points
        delegate?.scoreDidUpdate(currentScore)
    }

    private func loseLife() {
        // Reset multiplier on any missed or wrong catch
        consecutiveCatchCount = 0
        livesRemaining = max(0, livesRemaining - 1)
        delegate?.livesDidUpdate(livesRemaining)

        if livesRemaining <= 0 {
            endGame()
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
