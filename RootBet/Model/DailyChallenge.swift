//
//  DailyChallenge.swift
//  RootBet
//
//  Created by Пользователь on 11.06.2025.
//

import Foundation


struct DailyChallenge {
    let id: String
    let title: String
    let description: String
    let gameType: String
    let targetType: ChallengeTargetType
    let targetValue: Int
    let reward: Int
    var currentProgress: Int
    var isCompleted: Bool
    var isRewardClaimed: Bool
    
    enum ChallengeTargetType {
        case landCorrectColor(times: Int)
        case scorePoints(points: Int)
        case hitBonusColor(times: Int)
        case buildTowerHeight(blocks: Int)
        case stackPerfectBlocks(blocks: Int)
        case reachTotalPoints(points: Int)
        case catchBubblesWithoutMistake(bubbles: Int)
        case earnPointsInGame(points: Int)
        case avoidWrongBubbles(games: Int)
        case completePerfectSequences(sequences: Int)
        case memorizeSequence(symbols: Int)
        case playRoundsWithoutMistake(rounds: Int)
    }
}


extension DailyChallenge: Codable {
    enum CodingKeys: String, CodingKey {
        case id, title, description, gameType, targetType, targetValue, reward
        case currentProgress, isCompleted, isRewardClaimed
    }
    
    enum TargetTypeCodingKeys: String, CodingKey {
        case type, value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        gameType = try container.decode(String.self, forKey: .gameType)
        targetValue = try container.decode(Int.self, forKey: .targetValue)
        reward = try container.decode(Int.self, forKey: .reward)
        currentProgress = try container.decode(Int.self, forKey: .currentProgress)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        isRewardClaimed = try container.decode(Bool.self, forKey: .isRewardClaimed)
        
        // Decode targetType
        let targetTypeContainer = try container.nestedContainer(keyedBy: TargetTypeCodingKeys.self, forKey: .targetType)
        let type = try targetTypeContainer.decode(String.self, forKey: .type)
        let value = try targetTypeContainer.decode(Int.self, forKey: .value)
        
        switch type {
        case "landCorrectColor":
            targetType = .landCorrectColor(times: value)
        case "scorePoints":
            targetType = .scorePoints(points: value)
        case "hitBonusColor":
            targetType = .hitBonusColor(times: value)
        case "buildTowerHeight":
            targetType = .buildTowerHeight(blocks: value)
        case "stackPerfectBlocks":
            targetType = .stackPerfectBlocks(blocks: value)
        case "reachTotalPoints":
            targetType = .reachTotalPoints(points: value)
        case "catchBubblesWithoutMistake":
            targetType = .catchBubblesWithoutMistake(bubbles: value)
        case "earnPointsInGame":
            targetType = .earnPointsInGame(points: value)
        case "avoidWrongBubbles":
            targetType = .avoidWrongBubbles(games: value)
        case "completePerfectSequences":
            targetType = .completePerfectSequences(sequences: value)
        case "memorizeSequence":
            targetType = .memorizeSequence(symbols: value)
        case "playRoundsWithoutMistake":
            targetType = .playRoundsWithoutMistake(rounds: value)
        default:
            throw DecodingError.dataCorruptedError(forKey: .targetType, in: container, debugDescription: "Unknown target type")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(gameType, forKey: .gameType)
        try container.encode(targetValue, forKey: .targetValue)
        try container.encode(reward, forKey: .reward)
        try container.encode(currentProgress, forKey: .currentProgress)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(isRewardClaimed, forKey: .isRewardClaimed)
        
        // Encode targetType
        var targetTypeContainer = container.nestedContainer(keyedBy: TargetTypeCodingKeys.self, forKey: .targetType)
        
        switch targetType {
        case .landCorrectColor(let times):
            try targetTypeContainer.encode("landCorrectColor", forKey: .type)
            try targetTypeContainer.encode(times, forKey: .value)
        case .scorePoints(let points):
            try targetTypeContainer.encode("scorePoints", forKey: .type)
            try targetTypeContainer.encode(points, forKey: .value)
        case .hitBonusColor(let times):
            try targetTypeContainer.encode("hitBonusColor", forKey: .type)
            try targetTypeContainer.encode(times, forKey: .value)
        case .buildTowerHeight(let blocks):
            try targetTypeContainer.encode("buildTowerHeight", forKey: .type)
            try targetTypeContainer.encode(blocks, forKey: .value)
        case .stackPerfectBlocks(let blocks):
            try targetTypeContainer.encode("stackPerfectBlocks", forKey: .type)
            try targetTypeContainer.encode(blocks, forKey: .value)
        case .reachTotalPoints(let points):
            try targetTypeContainer.encode("reachTotalPoints", forKey: .type)
            try targetTypeContainer.encode(points, forKey: .value)
        case .catchBubblesWithoutMistake(let bubbles):
            try targetTypeContainer.encode("catchBubblesWithoutMistake", forKey: .type)
            try targetTypeContainer.encode(bubbles, forKey: .value)
        case .earnPointsInGame(let points):
            try targetTypeContainer.encode("earnPointsInGame", forKey: .type)
            try targetTypeContainer.encode(points, forKey: .value)
        case .avoidWrongBubbles(let games):
            try targetTypeContainer.encode("avoidWrongBubbles", forKey: .type)
            try targetTypeContainer.encode(games, forKey: .value)
        case .completePerfectSequences(let sequences):
            try targetTypeContainer.encode("completePerfectSequences", forKey: .type)
            try targetTypeContainer.encode(sequences, forKey: .value)
        case .memorizeSequence(let symbols):
            try targetTypeContainer.encode("memorizeSequence", forKey: .type)
            try targetTypeContainer.encode(symbols, forKey: .value)
        case .playRoundsWithoutMistake(let rounds):
            try targetTypeContainer.encode("playRoundsWithoutMistake", forKey: .type)
            try targetTypeContainer.encode(rounds, forKey: .value)
        }
    }
}
