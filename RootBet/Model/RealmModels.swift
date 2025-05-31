//
//  Realm Models.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import RealmSwift

// MARK: - Realm Models
class GameRecord: Object {
    @Persisted var gameType: String = ""
    @Persisted var score: Int = 0
    @Persisted var date: Date = Date()
    @Persisted var duration: TimeInterval = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @Persisted private var id: String = UUID().uuidString
}

class UserSettings: Object {
    @Persisted var soundEnabled: Bool = true
    @Persisted var hapticEnabled: Bool = true
    @Persisted var difficulty: String = "normal"
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    @Persisted private var userId: String = "main_user"
}
