//
//  UserDataService.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import RealmSwift
import UIKit


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
            defaultSettings.coins = 0
            defaultSettings.crystals = 0
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
    
    var avatarBackgroundColor: UIColor {
        get {
            guard let hex = getUserSettings()?.avatarBackgroundHex else {
                return UIColor(red: 0.50, green: 0.33, blue: 0.75, alpha: 1.0)
            }
            return UIColor(hex: hex)
        }
        set {
            guard let settings = getUserSettings() else { return }
            do {
                try realm.write {
                    settings.avatarBackgroundHex = newValue.toHexString()
                }
            } catch {
                print("Error updating avatarBackgroundColor: \(error)")
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
                
                // Notify observers about coins update
                NotificationCenter.default.post(
                    name: .coinsUpdated,
                    object: nil,
                    userInfo: ["newAmount": newValue]
                )
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
                
                // Notify observers about crystals update
                NotificationCenter.default.post(
                    name: .crystalsUpdated,
                    object: nil,
                    userInfo: ["newAmount": newValue]
                )
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
    
    func removeCoins(_ amount: Int) {
        let newAmount = max(0, coins - amount)
        coins = newAmount
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
    
    // MARK: - Daily Bonus Features
    
    // Infinite Life Management
    var hasInfiniteLife: Bool {
        guard let endTime = UserDefaults.standard.object(forKey: "InfiniteLifeEndTime") as? Date else {
            return false
        }
        return Date() < endTime
    }
    
    var infiniteLifeTimeRemaining: TimeInterval {
        guard let endTime = UserDefaults.standard.object(forKey: "InfiniteLifeEndTime") as? Date else {
            return 0
        }
        return max(0, endTime.timeIntervalSince(Date()))
    }
    
    func activateInfiniteLife(minutes: Int) {
        let endTime = Date().addingTimeInterval(TimeInterval(minutes * 60))
        UserDefaults.standard.set(endTime, forKey: "InfiniteLifeEndTime")
        
        // Notify games about infinite life activation
        NotificationCenter.default.post(
            name: .infiniteLifeActivated,
            object: nil,
            userInfo: ["minutes": minutes, "endTime": endTime]
        )
        
        print("🔥 Infinite Life activated for \(minutes) minutes")
    }
    
    // Time Bonus Management
    var timeBonusMinutes: Int {
        return UserDefaults.standard.integer(forKey: "TimeBonusMinutes")
    }
    
    func addTimeBonus(minutes: Int) {
        let currentBonus = timeBonusMinutes
        let newTotal = currentBonus + minutes
        UserDefaults.standard.set(newTotal, forKey: "TimeBonusMinutes")
        
        // Notify games about time bonus
        NotificationCenter.default.post(
            name: .timeBonusAdded,
            object: nil,
            userInfo: [
                "addedMinutes": minutes,
                "totalMinutes": newTotal
            ]
        )
        
        print("⏰ Time bonus added: +\(minutes) minutes (Total: \(newTotal))")
    }
    
    func consumeTimeBonus(minutes: Int) -> Bool {
        let currentBonus = timeBonusMinutes
        if currentBonus >= minutes {
            let remaining = currentBonus - minutes
            UserDefaults.standard.set(remaining, forKey: "TimeBonusMinutes")
            
            // Notify about time bonus consumption
            NotificationCenter.default.post(
                name: .timeBonusConsumed,
                object: nil,
                userInfo: [
                    "consumedMinutes": minutes,
                    "remainingMinutes": remaining
                ]
            )
            
            print("⏰ Time bonus consumed: -\(minutes) minutes (Remaining: \(remaining))")
            return true
        }
        return false
    }
    
    // MARK: - 2x Boost Management
    var has2xBoost: Bool {
        guard let endTime = UserDefaults.standard.object(forKey: "2xBoostEndTime") as? Date else {
            return false
        }
        return Date() < endTime
    }
    
    var boostTimeRemaining: TimeInterval {
        guard let endTime = UserDefaults.standard.object(forKey: "2xBoostEndTime") as? Date else {
            return 0
        }
        return max(0, endTime.timeIntervalSince(Date()))
    }
    
    func activate2xBoost(minutes: Int) {
        let endTime = Date().addingTimeInterval(TimeInterval(minutes * 60))
        UserDefaults.standard.set(endTime, forKey: "2xBoostEndTime")
        
        // Notify games about 2x boost activation
        NotificationCenter.default.post(
            name: .boost2xActivated,
            object: nil,
            userInfo: ["minutes": minutes, "endTime": endTime]
        )
        
        print("⚡ 2x Boost activated for \(minutes) minutes")
    }
    
    func get2xBoostStatus() -> (isActive: Bool, timeRemaining: String) {
        if has2xBoost {
            let remaining = boostTimeRemaining
            let hours = Int(remaining) / 3600
            let minutes = Int(remaining) % 3600 / 60
            
            let timeString = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
            return (true, timeString)
        }
        return (false, "")
    }
    
    // MARK: - Daily Bonus Statistics
    
    var totalDailyBonusesClaimed: Int {
        get {
            return UserDefaults.standard.integer(forKey: "TotalDailyBonusesClaimed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TotalDailyBonusesClaimed")
        }
    }
    
    var longestDailyStreak: Int {
        get {
            return UserDefaults.standard.integer(forKey: "LongestDailyStreak")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LongestDailyStreak")
        }
    }
    
    var currentDailyStreak: Int {
        get {
            return UserDefaults.standard.integer(forKey: "CurrentDailyStreak")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CurrentDailyStreak")
            
            // Update longest streak if needed
            if newValue > longestDailyStreak {
                longestDailyStreak = newValue
            }
        }
    }
    
    func recordDailyBonusClaim() {
        totalDailyBonusesClaimed += 1
        
        // Update streak
        let currentDay = UserDefaults.standard.integer(forKey: "CurrentDailyBonusDay")
        if currentDay == 7 {
            // Completed full week
            currentDailyStreak += 1
        }
    }
    
    // MARK: - Bonus Status Helpers
    
    func getInfiniteLifeStatus() -> (isActive: Bool, timeRemaining: String) {
        if hasInfiniteLife {
            let remaining = infiniteLifeTimeRemaining
            let hours = Int(remaining) / 3600
            let minutes = Int(remaining) % 3600 / 60
            
            let timeString = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
            return (true, timeString)
        }
        return (false, "")
    }
    
    func getTimeBonusStatus() -> (hasBonus: Bool, minutes: Int) {
        let minutes = timeBonusMinutes
        return (minutes > 0, minutes)
    }
    
    // MARK: - Game Integration Helpers
    
    func shouldShowInfiniteLifeIndicator() -> Bool {
        return hasInfiniteLife
    }
    
    func getGameTimerBonus() -> TimeInterval {
        return TimeInterval(timeBonusMinutes * 60)
    }
    
    var hasDoubleReward: Bool {
           guard let end = UserDefaults.standard.object(forKey: "DoubleRewardEndTime") as? Date
           else { return false }
           return Date() < end
       }

       var doubleRewardTimeRemaining: TimeInterval {
           guard let end = UserDefaults.standard.object(forKey: "DoubleRewardEndTime") as? Date
           else { return 0 }
           return max(0, end.timeIntervalSince(Date()))
       }

       func activateDoubleReward(minutes: Int) {
           let endTime = Date().addingTimeInterval(TimeInterval(minutes * 60))
           UserDefaults.standard.set(endTime, forKey: "DoubleRewardEndTime")

           NotificationCenter.default.post(
               name: .doubleRewardActivated,
               object: nil,
               userInfo: ["minutes": minutes, "endTime": endTime]
           )
       }
}

// MARK: - Notification Names
extension Notification.Name {
    static let coinsUpdated = Notification.Name("coinsUpdated")
    static let crystalsUpdated = Notification.Name("crystalsUpdated")
    static let infiniteLifeActivated = Notification.Name("infiniteLifeActivated")
    static let timeBonusAdded = Notification.Name("timeBonusAdded")
    static let timeBonusConsumed = Notification.Name("timeBonusConsumed")
    static let doubleRewardActivated = Notification.Name("doubleRewardActivated")
    static let boost2xActivated = Notification.Name("boost2xActivated")
}
