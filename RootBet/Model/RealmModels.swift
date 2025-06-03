//
//  Realm Models.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import RealmSwift
import Realm

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
    
    @Persisted var avatarImageName: String = "photoUser"
    @Persisted var avatarBackgroundHex: String = "#8346BC"


    @Persisted var coins: Int = 0
    @Persisted var crystals: Int = 0
    
    // New settings properties
    @Persisted var currentTheme: String = "Dark Mode"
    @Persisted var visualEffects: String = "Neon Glow"
    @Persisted var videoEnabled: Bool = true
    
    // Theme options
    @Persisted var availableThemes: List<String> = List<String>()
    
    // Visual effects options
    @Persisted var availableVisualEffects: List<String> = List<String>()
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    @Persisted var userId: String = "main_user"
    
    override init() {
        super.init()
        setupDefaultOptions()
    }
    
    private func setupDefaultOptions() {}
}
