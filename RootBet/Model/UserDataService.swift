//
//  UserDataService.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import RealmSwift


final class UserDataService {
    
    static let shared = UserDataService()
    private init() {
        ensureDefaultSettings()
    }
    
    private let realm = try! Realm()
    private let primaryKeyValue = "main_user"
    
    
    private func getUserSettings() -> UserSettings? {
        return realm.object(ofType: UserSettings.self, forPrimaryKey: primaryKeyValue)
    }
    
    
    private func ensureDefaultSettings() {
        if getUserSettings() == nil {
            let defaultSettings = UserSettings()
            defaultSettings.userId = primaryKeyValue
            try? realm.write {
                realm.add(defaultSettings)
            }
        }
    }
    
    var avatarImageName: String {
        get {
            return getUserSettings()?.avatarImageName ?? "default_avatar"
        }
        set {
            guard let settings = getUserSettings() else { return }
            try? realm.write {
                settings.avatarImageName = newValue
            }
        }
    }
    
    var coins: Int {
        get {
            return getUserSettings()?.coins ?? 0
        }
        set {
            guard let settings = getUserSettings() else { return }
            try? realm.write {
                settings.coins = newValue
            }
        }
    }
    
    
    var crystals: Int {
        get {
            return getUserSettings()?.crystals ?? 0
        }
        set {
            guard let settings = getUserSettings() else { return }
            try? realm.write {
                settings.crystals = newValue
            }
        }
    }
    
    
    var soundEnabled: Bool {
        get {
            return getUserSettings()?.soundEnabled ?? true
        }
        set {
            guard let settings = getUserSettings() else { return }
            try? realm.write {
                settings.soundEnabled = newValue
            }
        }
    }
    
    var hapticEnabled: Bool {
        get {
            return getUserSettings()?.hapticEnabled ?? true
        }
        set {
            guard let settings = getUserSettings() else { return }
            try? realm.write {
                settings.hapticEnabled = newValue
            }
        }
    }
}

