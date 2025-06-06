//
//  AppDelegate.swift
//  RootBet
//
//  Created by Пользователь on 31.05.2025.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        let config = Realm.Configuration(
            schemaVersion: 2, // Increment version number
            migrationBlock: { migration, oldSchemaVersion in
                
                // Migration from version 1 to 2
                if oldSchemaVersion < 2 {
                    
                    // Migrate UserSettings
                    migration.enumerateObjects(ofType: UserSettings.className()) { oldObject, newObject in
                        
                        // Add new properties with default values
                        newObject!["currentTheme"] = "Dark Mode"
                        newObject!["visualEffects"] = "Neon Glow"
                        newObject!["videoEnabled"] = true
                        
                        // For List properties, we'll initialize them as empty lists
                        // They will be populated when UserDataService creates default settings
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        // Test Realm initialization
        do {
            _ = try Realm()
            print("Realm successfully configured")
        } catch {
            print("Error initializing Realm: \(error)")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

