//
//  BubbleCatchViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import RealmSwift


class BubbleCatchViewModel: BaseGameViewModel {
    override var gameType: GameType { .bubbleCatch }
    
    @Published var bubbles: [BubbleItem] = []
    @Published var basketPosition: CGFloat = 0
    
    private var bubbleTimer: Timer?
    private let bubbleColors: [UIColor] = [.red, .blue, .green, .yellow, .orange]
    
    override func startGame() {
        bubbles = []
        basketPosition = 0
        super.startGame()
        startBubbleGeneration()
    }
    
    override func endGame() {
        super.endGame()
        bubbleTimer?.invalidate()
    }
    
    private func startBubbleGeneration() {
        bubbleTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.createBubble()
        }
    }
    
    private func createBubble() {
        guard isGameActive else { return }
        
        let bubble = BubbleItem(
            color: bubbleColors.randomElement() ?? .blue,
            points: Int.random(in: 5...20),
            position: CGPoint(x: CGFloat.random(in: 0...300), y: 0),
            velocity: CGVector(dx: 0, dy: CGFloat.random(in: 1...3))
        )
        
        bubbles.append(bubble)
        animateBubbles()
    }
    
    private func animateBubbles() {
        for i in bubbles.indices.reversed() {
            bubbles[i].position.y += bubbles[i].velocity.dy
            
            if bubbles[i].position.y > 600 {
                bubbles.remove(at: i)
            } else if checkCollision(bubble: bubbles[i]) {
                let points = bubbles[i].points
                updateScore(score + points)
                HapticManager.shared.impact(.light)
                bubbles.remove(at: i)
            }
        }
    }
    
    private func checkCollision(bubble: BubbleItem) -> Bool {
        let basketRect = CGRect(x: basketPosition - 40, y: 500, width: 80, height: 40)
        let bubbleRect = CGRect(x: bubble.position.x - 15, y: bubble.position.y - 15, width: 30, height: 30)
        return basketRect.intersects(bubbleRect)
    }
    
    func moveBasket(to position: CGFloat) {
        basketPosition = max(-150, min(150, position))
    }
}
