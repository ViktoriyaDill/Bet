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
        let existingSettings = getUserSettings()
        
        if existingSettings == nil {
            // Create new settings
            let defaultSettings = UserSettings()
            defaultSettings.userId = primaryKeyValue
            defaultSettings.avatarImageName = "photoUser"
            defaultSettings.coins = 1000
            defaultSettings.crystals = 50
            defaultSettings.currentTheme = "Dark Mode"
            defaultSettings.visualEffects = "Neon Glow"
            defaultSettings.videoEnabled = true
            
            do {
                try realm.write {
                    // Initialize theme options
                    defaultSettings.availableThemes.append(objectsIn: ["Dark Mode", "Light Mode", "Classic Mode"])
                    
                    // Initialize visual effects options
                    defaultSettings.availableVisualEffects.append(objectsIn: ["Neon Glow", "Ice Crystals", "Aurora Effect", "No Effects"])
                    
                    realm.add(defaultSettings)
                }
            } catch {
                print("Error creating default settings: \(error)")
            }
        } else {
            // Update existing settings if needed
            guard let settings = existingSettings else { return }
            
            do {
                try realm.write {
                    // Initialize lists if they're empty (after migration)
                    if settings.availableThemes.isEmpty {
                        settings.availableThemes.append(objectsIn: ["Dark Mode", "Light Mode", "Classic Mode"])
                    }
                    
                    if settings.availableVisualEffects.isEmpty {
                        settings.availableVisualEffects.append(objectsIn: ["Neon Glow", "Ice Crystals", "Aurora Effect", "No Effects"])
                    }
                }
            } catch {
                print("Error updating existing settings: \(error)")
            }
        }
    }
    
    var avatarImageName: String {
        get {
            return getUserSettings()?.avatarImageName ?? "photoUser"
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.avatarImageName = newValue
                }
            } catch {
                print("Error updating avatar: \(error)")
            }
        }
    }
    
    var coins: Int {
        get {
            return getUserSettings()?.coins ?? 0
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.coins = newValue
                }
            } catch {
                print("Error updating coins: \(error)")
            }
        }
    }
    
    
    var crystals: Int {
        get {
            return getUserSettings()?.crystals ?? 0
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.crystals = newValue
                }
            } catch {
                print("Error updating crystals: \(error)")
            }
        }
    }
    
    
    var soundEnabled: Bool {
        get {
            return getUserSettings()?.soundEnabled ?? true
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.soundEnabled = newValue
                }
            } catch {
                print("Error updating sound setting: \(error)")
            }
        }
    }
    
    var hapticEnabled: Bool {
        get {
            return getUserSettings()?.hapticEnabled ?? true
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.hapticEnabled = newValue
                }
            } catch {
                print("Error updating haptic setting: \(error)")
            }
        }
    }
    
    // MARK: - Additional Settings Properties
    var currentTheme: String {
        get {
            return getUserSettings()?.currentTheme ?? "Dark Mode"
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.currentTheme = newValue
                }
            } catch {
                print("Error updating theme: \(error)")
            }
        }
    }
    
    var visualEffects: String {
        get {
            return getUserSettings()?.visualEffects ?? "Neon Glow"
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.visualEffects = newValue
                }
            } catch {
                print("Error updating visual effects: \(error)")
            }
        }
    }
    
    var videoEnabled: Bool {
        get {
            return getUserSettings()?.videoEnabled ?? true
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.videoEnabled = newValue
                }
            } catch {
                print("Error updating video setting: \(error)")
            }
        }
    }
    
    // MARK: - Game Statistics
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }
    
    func addCrystals(_ amount: Int) {
        crystals += amount
    }
    
    func spendCrystals(_ amount: Int) -> Bool {
        if crystals >= amount {
            crystals -= amount
            return true
        }
        return false
    }
}
