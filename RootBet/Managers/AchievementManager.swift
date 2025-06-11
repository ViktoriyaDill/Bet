//
//  AchievementManager.swift
//  RootBet
//
//  Created by Пользователь on 12.06.2025.
//

import Foundation
import UIKit


class AchievementManager {
    static let shared = AchievementManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let achievementsKey = "Achievements"
    
    func getAllAchievements() -> [Achievement] {
        if let data = userDefaults.data(forKey: achievementsKey),
           let achievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            return achievements
        } else {
            return generateDefaultAchievements()
        }
    }
    
    private func generateDefaultAchievements() -> [Achievement] {
        let achievements = [
            // Game Progress
            Achievement(id: "first_steps", title: "First Steps", description: "Play your first game", iconName: "first_steps", category: .gameProgress, type: .playFirstGame, targetValue: 1, currentProgress: 0, isCompleted: false, reward: 50),
            Achievement(id: "spin_master", title: "Spin Master", description: "Win 10 rounds in Color Spin", iconName: "spin_master", category: .gameProgress, type: .winColorSpinRounds, targetValue: 10, currentProgress: 0, isCompleted: false, reward: 100),
            Achievement(id: "tower_builder", title: "Tower Builder", description: "Stack 50 blocks in Stack Tower", iconName: "tower_builder", category: .gameProgress, type: .stackBlocks, targetValue: 50, currentProgress: 0, isCompleted: false, reward: 150),
            Achievement(id: "bubble_expert", title: "Bubble Expert", description: "Catch 100 correct bubbles in Bubble Catch", iconName: "tower_builder", category: .gameProgress, type: .catchBubbles, targetValue: 100, currentProgress: 0, isCompleted: false, reward: 200),
            Achievement(id: "memory_champion", title: "Memory Champion", description: "Complete 5 levels of Memory Match without mistakes", iconName: "memory_champion", category: .gameProgress, type: .memoryLevels, targetValue: 5, currentProgress: 0, isCompleted: false, reward: 250),
            Achievement(id: "versatile_player", title: "Versatile Player", description: "Play all four game modes at least once", iconName: "versatile_player", category: .gameProgress, type: .playAllGames, targetValue: 4, currentProgress: 0, isCompleted: false, reward: 300),
            Achievement(id: "endless_spinner", title: "Endless Spinner", description: "Play 50 rounds of Color Spin", iconName: "endless_spinner", category: .gameProgress, type: .playColorSpinRounds, targetValue: 50, currentProgress: 0, isCompleted: false, reward: 350),
            Achievement(id: "unstoppable_stacker", title: "Unstoppable Stacker", description: "Place 500 blocks in Stack Tower across all games", iconName: "unstoppable_stacker", category: .gameProgress, type: .placeBlocksTotal, targetValue: 500, currentProgress: 0, isCompleted: false, reward: 400),
            
            // Daily & Weekly Activity
            Achievement(id: "daily_challenger", title: "Daily Challenger", description: "Complete 3 daily challenges", iconName: "daily_challenger", category: .dailyWeekly, type: .completeDailyChallenges, targetValue: 3, currentProgress: 0, isCompleted: false, reward: 100),
            Achievement(id: "weekly_warrior", title: "Weekly Warrior", description: "Log in 7 days in a row", iconName: "spin_master", category: .dailyWeekly, type: .loginStreak, targetValue: 7, currentProgress: 0, isCompleted: false, reward: 200),
            Achievement(id: "lucky_spinner", title: "Lucky Spinner", description: "Spin the prize wheel 5 times", iconName: "endless_spinner", category: .dailyWeekly, type: .spinWheel, targetValue: 5, currentProgress: 0, isCompleted: false, reward: 150),
            Achievement(id: "event_explorer", title: "Event Explorer", description: "Participate in a special in-game event", iconName: "event_explorer", category: .dailyWeekly, type: .participateEvent, targetValue: 1, currentProgress: 0, isCompleted: false, reward: 300),
            
            // Record
            Achievement(id: "high_score_hunter", title: "High Score Hunter", description: "Score 1000 points in a single Color Spin game", iconName: "high_score_hunter", category: .record, type: .highScoreColorSpin, targetValue: 1000, currentProgress: 0, isCompleted: false, reward: 500),
            Achievement(id: "ultimate_tower", title: "Ultimate Tower", description: "Build a 100-level tower in Stack Tower", iconName: "ultimate_tower", category: .record, type: .buildUltimateTower, targetValue: 100, currentProgress: 0, isCompleted: false, reward: 600),
            Achievement(id: "memory_genius", title: "Memory Genius", description: "Remember and repeat a 10-symbol sequence in Memory Match", iconName: "memory_genius", category: .record, type: .memorySequence, targetValue: 10, currentProgress: 0, isCompleted: false, reward: 400),
            Achievement(id: "bubble_streak", title: "Bubble Streak", description: "Catch 20 bubbles in a row without mistakes in Bubble Catch", iconName: "bubble_streak", category: .record, type: .bubbleStreak, targetValue: 20, currentProgress: 0, isCompleted: false, reward: 350),
            
            // Special Rewards
            Achievement(id: "collectors_pride", title: "Collector's Pride", description: "Unlock all available skins", iconName: "collectors_pride", category: .specialRewards, type: .unlockSkins, targetValue: 10, currentProgress: 0, isCompleted: false, reward: 1000),
            Achievement(id: "strategic_mind", title: "Strategic Mind", description: "Complete 50 daily challenges", iconName: "strategic_mind", category: .specialRewards, type: .completeChallenges, targetValue: 50, currentProgress: 0, isCompleted: false, reward: 800),
            Achievement(id: "elite_player", title: "Elite Player", description: "Earn 10,000 in-game coins", iconName: "elite_player", category: .specialRewards, type: .earnCoins, targetValue: 10000, currentProgress: 0, isCompleted: false, reward: 1500),
            Achievement(id: "master_of_games", title: "Master of Games", description: "Reach level 50 in any game mode", iconName: "master_of_games", category: .specialRewards, type: .reachLevel, targetValue: 50, currentProgress: 0, isCompleted: false, reward: 2000)
        ]
        
        saveAchievements(achievements)
        return achievements
    }
    
    private func saveAchievements(_ achievements: [Achievement]) {
        if let data = try? JSONEncoder().encode(achievements) {
            userDefaults.set(data, forKey: achievementsKey)
        }
    }
    
    func updateProgress(type: Achievement.AchievementType, progress: Int) {
        var achievements = getAllAchievements()
        var updated = false
        
        for i in 0..<achievements.count {
            if achievements[i].type == type && !achievements[i].isCompleted {
                let oldProgress = achievements[i].currentProgress
                achievements[i].currentProgress = max(achievements[i].currentProgress, progress)
                
                if achievements[i].currentProgress >= achievements[i].targetValue {
                    achievements[i].isCompleted = true
                    // Award achievement reward
                    UserDataService.shared.addCoins(achievements[i].reward)
                    showAchievementUnlocked(achievements[i])
                }
                
                if achievements[i].currentProgress != oldProgress {
                    updated = true
                }
            }
        }
        
        if updated {
            saveAchievements(achievements)
            NotificationCenter.default.post(name: NSNotification.Name("AchievementProgressUpdated"), object: nil)
        }
    }
    
    func checkAllAchievements() {
        // Check coin-based achievement
        updateProgress(type: .earnCoins, progress: UserDataService.shared.coins)
        
        // Other achievements should be updated from game controllers
    }
    
    private func showAchievementUnlocked(_ achievement: Achievement) {
        DispatchQueue.main.async {
            // Get the current top view controller
            if let topViewController = UIApplication.shared.topViewController() {
                let popup = AchievementUnlockPopup(achievement: achievement)
                popup.show(in: topViewController.view)
            }
            
            // Also post notification for any other listeners
            NotificationCenter.default.post(
                name: NSNotification.Name("AchievementUnlocked"),
                object: nil,
                userInfo: ["achievement": achievement]
            )
        }
    }
}
