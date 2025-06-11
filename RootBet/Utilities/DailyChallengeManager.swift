//
//  DailyChallengeManager.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import Foundation
import UIKit


class DailyChallengeManager {
    static let shared = DailyChallengeManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let challengesKey = "DailyChallenges"
    private let lastResetKey = "LastChallengeReset"
    
    func getDailyChallenges() -> [DailyChallenge] {
          checkAndResetIfNeeded()
          
          if let data = userDefaults.data(forKey: challengesKey),
             let challenges = try? JSONDecoder().decode([DailyChallenge].self, from: data) {
              return challenges
          } else {
              return generateNewChallenges()
          }
      }
    
    private func generateNewChallenges() -> [DailyChallenge] {
        let challenges = [
            DailyChallenge(
                id: "color_spin_correct_10",
                title: "Color Spin Master",
                description: "Land on the correct color 10 times in a row in Color Spin",
                gameType: "ColorSpin",
                targetType: .landCorrectColor(times: 10),
                targetValue: 10,
                reward: 100,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "color_spin_score_500",
                title: "High Scorer",
                description: "Score 500 points in a single game of Color Spin",
                gameType: "ColorSpin",
                targetType: .scorePoints(points: 500),
                targetValue: 500,
                reward: 300,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "color_spin_bonus_5",
                title: "Bonus Hunter",
                description: "Hit the bonus color 5 times today in Color Spin",
                gameType: "ColorSpin",
                targetType: .hitBonusColor(times: 5),
                targetValue: 5,
                reward: 500,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            // Stack Tower challenges
            DailyChallenge(
                id: "stack_tower_height_30",
                title: "Tower Builder",
                description: "Build a tower 30 blocks high in Stack Tower",
                gameType: "StackTower",
                targetType: .buildTowerHeight(blocks: 30),
                targetValue: 30,
                reward: 100,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "stack_tower_perfect_10",
                title: "Perfect Stacker",
                description: "Stack 10 perfect blocks in one game of Stack Tower",
                gameType: "StackTower",
                targetType: .stackPerfectBlocks(blocks: 10),
                targetValue: 10,
                reward: 300,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "stack_tower_total_1000",
                title: "Point Collector",
                description: "Reach a total of 1000 points today in Stack Tower",
                gameType: "StackTower",
                targetType: .reachTotalPoints(points: 1000),
                targetValue: 1000,
                reward: 500,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            // Bubble Catch challenges
            DailyChallenge(
                id: "bubble_catch_correct_50",
                title: "Bubble Master",
                description: "Catch 50 correct bubbles without a mistake in Bubble Catch",
                gameType: "BubbleCatch",
                targetType: .catchBubblesWithoutMistake(bubbles: 50),
                targetValue: 50,
                reward: 100,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "bubble_catch_score_750",
                title: "Bubble Champion",
                description: "Earn 750 points in a single game of Bubble Catch",
                gameType: "BubbleCatch",
                targetType: .earnPointsInGame(points: 750),
                targetValue: 750,
                reward: 300,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "bubble_catch_avoid_3_games",
                title: "Flawless Player",
                description: "Avoid all wrong bubbles for 3 games in a row in Bubble Catch",
                gameType: "BubbleCatch",
                targetType: .avoidWrongBubbles(games: 3),
                targetValue: 3,
                reward: 500,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            // Memory Match challenges
            DailyChallenge(
                id: "memory_match_sequences_5",
                title: "Memory Expert",
                description: "Complete 5 perfect sequences in a row in Memory Match",
                gameType: "MemoryMatch",
                targetType: .completePerfectSequences(sequences: 5),
                targetValue: 5,
                reward: 100,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "memory_match_12_symbol",
                title: "Memory Master",
                description: "Memorize and repeat a 12-symbol sequence in Memory Match",
                gameType: "MemoryMatch",
                targetType: .memorizeSequence(symbols: 12),
                targetValue: 12,
                reward: 300,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            ),
            DailyChallenge(
                id: "memory_match_perfect_3",
                title: "Flawless Memory",
                description: "Play 3 rounds without a single mistake in Memory Match",
                gameType: "MemoryMatch",
                targetType: .playRoundsWithoutMistake(rounds: 3),
                targetValue: 3,
                reward: 500,
                currentProgress: 0,
                isCompleted: false,
                isRewardClaimed: false
            )
        ]
        
        saveChallenges(challenges)
        return challenges
    }
    
    private func saveChallenges(_ challenges: [DailyChallenge]) {
        if let data = try? JSONEncoder().encode(challenges) {
            userDefaults.set(data, forKey: challengesKey)
        }
    }
    
    private func checkAndResetIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastReset = userDefaults.object(forKey: lastResetKey) as? Date {
            let lastResetDay = calendar.startOfDay(for: lastReset)
            
            if today > lastResetDay {
                resetDailyChallenges()
            }
        } else {
            userDefaults.set(today, forKey: lastResetKey)
        }
    }
    
    func resetDailyChallenges() {
        let newChallenges = generateNewChallenges()
        saveChallenges(newChallenges)
        userDefaults.set(Date(), forKey: lastResetKey)
    }
    
    func updateProgress(gameType: String, progress: [String: Any]) {
        var challenges = getDailyChallenges()
        var updated = false
        
        for i in 0..<challenges.count {
            if challenges[i].gameType == gameType && !challenges[i].isCompleted {
                let oldProgress = challenges[i].currentProgress
                challenges[i].currentProgress = calculateProgress(for: challenges[i], with: progress)
                
                if challenges[i].currentProgress >= challenges[i].targetValue {
                    challenges[i].isCompleted = true
                }
                
                if challenges[i].currentProgress != oldProgress {
                    updated = true
                }
            }
        }
        
        if updated {
            saveChallenges(challenges)
        }
    }
    
    private func calculateProgress(for challenge: DailyChallenge, with progress: [String: Any]) -> Int {
        switch challenge.targetType {
        case .landCorrectColor(let times):
            return progress["correctStreak"] as? Int ?? challenge.currentProgress
        case .scorePoints(let points):
            return max(challenge.currentProgress, progress["score"] as? Int ?? 0)
        case .hitBonusColor(let times):
            return (progress["bonusHits"] as? Int ?? 0) + challenge.currentProgress
        case .buildTowerHeight(let blocks):
            return max(challenge.currentProgress, progress["towerHeight"] as? Int ?? 0)
        case .stackPerfectBlocks(let blocks):
            return max(challenge.currentProgress, progress["perfectBlocks"] as? Int ?? 0)
        case .reachTotalPoints(let points):
            return (progress["sessionPoints"] as? Int ?? 0) + challenge.currentProgress
        case .catchBubblesWithoutMistake(let bubbles):
            return progress["correctStreak"] as? Int ?? challenge.currentProgress
        case .earnPointsInGame(let points):
            return max(challenge.currentProgress, progress["score"] as? Int ?? 0)
        case .avoidWrongBubbles(let games):
            let perfectGames = progress["perfectGames"] as? Int ?? 0
            return perfectGames + challenge.currentProgress
        case .completePerfectSequences(let sequences):
            return progress["perfectStreak"] as? Int ?? challenge.currentProgress
        case .memorizeSequence(let symbols):
            return max(challenge.currentProgress, progress["sequenceLength"] as? Int ?? 0)
        case .playRoundsWithoutMistake(let rounds):
            return progress["perfectRounds"] as? Int ?? challenge.currentProgress
        }
    }
    
    func checkChallengeProgress(_ challenge: DailyChallenge) {
        // This method can be called to manually check if a challenge should be completed
        // based on current game state
    }
    
    func claimReward(for challenge: DailyChallenge) {
        var challenges = getDailyChallenges()
        
        for i in 0..<challenges.count {
            if challenges[i].id == challenge.id && challenges[i].isCompleted && !challenges[i].isRewardClaimed {
                challenges[i].isRewardClaimed = true
                UserDataService.shared.addCoins(challenge.reward)
                break
            }
        }
        
        saveChallenges(challenges)
    }
}
