//
//  UserDefaults+Ext.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation


extension UserDefaults {
    func hasCompletedOnboarding() -> Bool {
        return bool(forKey: "hasCompletedOnboarding")
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        set(completed, forKey: "hasCompletedOnboarding")
    }
}
