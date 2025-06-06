//
//  BaseGameViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import RealmSwift

protocol GameViewModelDelegate: AnyObject {
    func gameDidStart()
    func gameDidEnd(score: Int)
    func scoreDidUpdate(_ score: Int)
}

class BaseGameViewModel: ObservableObject {
    weak var delegate: GameViewModelDelegate?
    
    @Published var score: Int = 0
    @Published var isGameActive: Bool = false
    @Published var timeRemaining: TimeInterval = 60
    
    private var gameTimer: Timer?
    private let realm = try! Realm()
    
    var gameType: GameType { fatalError("Must be overridden") }
    
    func startGame() {
        isGameActive = true
        score = 0
        timeRemaining = 60
        delegate?.gameDidStart()
        startTimer()
    }
    
    func endGame() {
        isGameActive = false
        gameTimer?.invalidate()
        saveScore()
        delegate?.gameDidEnd(score: score)
    }
    
    private func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.endGame()
            }
        }
    }
    
    private func saveScore() {
        let record = GameRecord()
        record.gameType = gameType.rawValue
        record.score = score
        record.date = Date()
        record.duration = 60 - timeRemaining
        
        try! realm.write {
            realm.add(record)
        }
    }
    
    func updateScore(_ newScore: Int) {
        score = newScore
        delegate?.scoreDidUpdate(score)
    }
}
