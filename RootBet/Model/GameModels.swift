//
//  GameModels.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit

enum GameType: String, CaseIterable {
    case colorSpin = "Color Spin"
    case stackTower = "Stack Tower"
    case bubbleCatch = "Bubble Catch"
    case memoryMatch = "Memory Match"
}

enum MenuButtonModel: String, CaseIterable {
    case game = "GAME"
    case bonus = "BONUS"
    case settings = "SETTIGS"
    
    var imageName: String {
        switch self {
        case .game:
            return "game-purple"
        case .bonus:
            return "bonus-purple"
        case .settings:
            return "settings-purple"
        }
    }
    
    var image: UIImage? {
        return UIImage(named: imageName)
    }
}

struct GameDetailModel {
    let title: String
    let description: String
    let image: UIImage
}


enum ResultType {
    case win
    case lost
}

struct ColorSpinItem {
    let color: UIColor
    let coins: Int
}

struct StackTowerBlock {
    let id: UUID = UUID()
    let width: CGFloat
    let color: UIColor
    var position: CGPoint
}

struct BubbleItem {
    let id: UUID = UUID()
    let color: UIColor
    let points: Int
    var position: CGPoint
    var velocity: CGVector
}

struct MemoryCard {
    let id: UUID = UUID()
    let symbol: String
    let color: UIColor
    var isFlipped: Bool = false
    var isMatched: Bool = false
}
