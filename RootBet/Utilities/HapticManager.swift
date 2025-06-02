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
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        notificationGenerator.prepare()
    }
    
    func lightTap() {
        lightImpact.impactOccurred()
    }
    
    func mediumTap() {
        mediumImpact.impactOccurred()
    }
    
    func heavyTap() {
        heavyImpact.impactOccurred()
    }
    
    func success() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    func warning() {
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func error() {
        notificationGenerator.notificationOccurred(.error)
    }
}
