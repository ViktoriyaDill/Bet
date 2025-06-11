//
//  DailyBonus.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//


struct DailyBonus {
    let day: Int
    let type: BonusType
    let amount: Int
    
    var finalAmount: Int {
        return day == 7 ? amount * 2 : amount
    }
    
    enum BonusType: Codable {
        case coins
        case crystals
        case infiniteLife15
        case infiniteLife30
        case timeBonus5
        case timeBonus10
        case megaReward
    }
}