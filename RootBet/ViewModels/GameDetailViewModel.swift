//
//  GameDetailViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit


final class GameDetailViewModel {

    
    private(set) var games: [GameDetailModel] = []

    private(set) var currentIndex: Int = 0 {
        didSet {
            onIndexChanged?(currentIndex)
        }
    }

    var onIndexChanged: ((Int) -> Void)?


    init(startIndex: Int = 0) {
        games = [
            GameDetailModel(
                title: "Color Spin",
                description: "Test your reflexes and precision by stopping the spinning color wheel on the correct section! The faster and more accurately you stop it, the higher your rewards.",
                image: UIImage(named: "ColorSpin")!
            ),
            GameDetailModel(
                title: "Stack Tower",
                description: "Your goal is simple: stack blocks on top of each other to build the tallest tower possible! The more precise your placement, the higher your score.",
                image: UIImage(named: "StackTower")!
            ),
            GameDetailModel(
                title: "Bubble Catch",
                description: "Catch the falling bubbles in the correct zones while avoiding the wrong ones! The more accurate your catches, the higher your score.",
                image: UIImage(named: "BubbleCatch")!
            ),
            GameDetailModel(
                title: "Memory Match",
                description: "\"Memory Match\" is a memory-based game where players must remember and repeat symbol sequences correctly.",
                image: UIImage(named: "MemoryMatch")!
            )
        ]

        if startIndex >= 0 && startIndex < games.count {
            self.currentIndex = startIndex
        } else {
            self.currentIndex = 0
        }
    }

    var canGoNext: Bool {
           return currentIndex < games.count - 1
       }
       
       var canGoPrevious: Bool {
           return currentIndex > 0
       }
       

       func goToNext() {
           guard canGoNext else { return }
           currentIndex += 1
       }

       func goToPrevious() {
           guard canGoPrevious else { return }
           currentIndex -= 1
       }

    func currentGame() -> GameDetailModel {
        return games[currentIndex]
    }
}

