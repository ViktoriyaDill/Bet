//
//  AchievementModel.swift
//  RootBet
//
//  Created by Пользователь on 12.06.2025.
//

import Foundation


struct Achievement: Codable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let category: AchievementCategory
    let type: AchievementType
    let targetValue: Int
    var currentProgress: Int
    var isCompleted: Bool
    let reward: Int
    
    enum AchievementCategory: String, Codable {
        case gameProgress = "gameProgress"
        case dailyWeekly = "dailyWeekly"
        case record = "record"
        case specialRewards = "specialRewards"
    }
    
    enum AchievementType: String, Codable {
        case playFirstGame = "playFirstGame"
        case winColorSpinRounds = "winColorSpinRounds"
        case stackBlocks = "stackBlocks"
        case catchBubbles = "catchBubbles"
        case memoryLevels = "memoryLevels"
        case playAllGames = "playAllGames"
        case playColorSpinRounds = "playColorSpinRounds"
        case placeBlocksTotal = "placeBlocksTotal"
        case completeDailyChallenges = "completeDailyChallenges"
        case loginStreak = "loginStreak"
        case spinWheel = "spinWheel"
        case participateEvent = "participateEvent"
        case highScoreColorSpin = "highScoreColorSpin"
        case buildUltimateTower = "buildUltimateTower"
        case memorySequence = "memorySequence"
        case bubbleStreak = "bubbleStreak"
        case unlockSkins = "unlockSkins"
        case completeChallenges = "completeChallenges"
        case earnCoins = "earnCoins"
        case reachLevel = "reachLevel"
    }
}
