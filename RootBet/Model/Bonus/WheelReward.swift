//
//  WheelReward.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import Foundation


enum WheelReward: CaseIterable {
    case plusTimer5    
    case crystals5
    case infiniteLife15
    case plusTimer5b
    case freeSpin
    case x2Boost5m
    case infiniteLife30
    case coins500
    
    var title: String {
        switch self {
        case .plusTimer5, .plusTimer5b: return "+5 Minutes Timer"
        case .crystals5: return "5 Crystals"
        case .infiniteLife15: return "15 Min Infinite Life"
        case .freeSpin: return "Free Spin"
        case .x2Boost5m: return "2x Boost 5 Min"
        case .infiniteLife30: return "30 Min Infinite Life"
        case .coins500: return "500 Coins"
        }
    }
    
    var description: String {
        switch self {
        case .plusTimer5, .plusTimer5b: return "Game timer extended by 5 minutes"
        case .crystals5: return "You received 5 crystals"
        case .infiniteLife15: return "Infinite life for 15 minutes"
        case .freeSpin: return "You got an extra free spin"
        case .x2Boost5m: return "All bonuses doubled for 5 minutes"
        case .infiniteLife30: return "Infinite life for 30 minutes"
        case .coins500: return "You received 500 coins"
        }
    }
}
