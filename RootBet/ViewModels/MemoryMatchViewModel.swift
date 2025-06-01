//
//  MemoryMatchViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import RealmSwift


class MemoryMatchViewModel: BaseGameViewModel {
    override var gameType: GameType { .memoryMatch }
    
    @Published var cards: [MemoryCard] = []
    @Published var flippedCards: [UUID] = []
    @Published var matchedPairs: Int = 0
    
    private let symbols = ["🌟", "🎯", "🎪", "🎨", "🎭", "🎪", "🎯", "🌟"]
    private let cardColors: [UIColor] = [.systemPurple, .systemBlue, .systemGreen, .systemOrange]
    
    override func startGame() {
        setupCards()
        super.startGame()
    }
    
    private func setupCards() {
        var gameCards: [MemoryCard] = []
        
        for symbol in symbols {
            let color = cardColors.randomElement() ?? .systemPurple
            gameCards.append(MemoryCard(symbol: symbol, color: color))
        }
        
        cards = gameCards.shuffled()
        flippedCards = []
        matchedPairs = 0
    }
    
    func flipCard(at index: Int) {
        guard isGameActive,
              !cards[index].isFlipped,
              !cards[index].isMatched,
              flippedCards.count < 2 else { return }
        
        cards[index].isFlipped = true
        flippedCards.append(cards[index].id)
        HapticManager.shared.impact(.light)
        
        if flippedCards.count == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.checkForMatch()
            }
        }
    }
    
    private func checkForMatch() {
        guard flippedCards.count == 2 else { return }
        
        let firstIndex = cards.firstIndex { $0.id == flippedCards[0] }!
        let secondIndex = cards.firstIndex { $0.id == flippedCards[1] }!
        
        if cards[firstIndex].symbol == cards[secondIndex].symbol {
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            matchedPairs += 1
            updateScore(score + 20)
            HapticManager.shared.notification(.success)
            
            if matchedPairs == symbols.count {
                endGame()
            }
        } else {
            cards[firstIndex].isFlipped = false
            cards[secondIndex].isFlipped = false
            HapticManager.shared.notification(.error)
        }
        
        flippedCards.removeAll()
    }
}
