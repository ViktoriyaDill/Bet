//
//  MemoryMatchViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import RealmSwift



class MemoryMatchViewModel {
    
    weak var delegate: GameViewModelDelegate?
    
    // MARK: - Game Data
    private(set) var currentScore = 0
    private var gameTime = 0
    
    
    let availableCrystals = [
        "aqva",
        "blue",
        "darkGreen",
        "green",
        "orange",
        "pink",
        "purple",
        "red",
        "yellow"
    ]
    
    // MARK: - Game Control
    
    // MARK: - Game Control
    func startGame() {
        currentScore = 0
        gameTime = 0
        delegate?.gameDidStart()
    }
    
    func endGame() {
        delegate?.gameDidEnd(score: currentScore)
    }
    
    func resetGame() {
        currentScore = 0
        gameTime = 0
    }
    
    func addScore(_ points: Int) {
        currentScore += points
        delegate?.scoreDidUpdate(currentScore)
    }
}
