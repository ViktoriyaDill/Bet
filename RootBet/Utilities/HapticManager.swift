//
//  HapticManager.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit


class HapticManager {
    static let shared = HapticManager()
    private init() {}
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
}
