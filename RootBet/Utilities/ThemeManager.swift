//
//  ThemeManager.swift
//  RootBet
//
//  Created by Пользователь on 03.06.2025.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    private init() {}

    private let userService = UserDataService.shared

    // MARK: - Background Color or Image

    func getBackgroundColor(for theme: String, effects: String) -> UIColor {
        if effects == "Ice Chill" {
            return .clear
        }
        switch theme {
        case "Classic Mode":
            return UIColor(red: 0.28, green: 0.23, blue: 0.44, alpha: 1.00)
        default:
            return .clear 
        }
    }

    func getBackgroundImageName(for theme: String, effects: String) -> String? {
        if effects == "Ice Chill" {
            return "IceBG"
        }
        switch theme {
        case "Light Mode":
            return "BGLightMode"
        case "Dark Mode":
            return "BG 1"
        default:
            return nil
        }
    }


    // MARK: - Visual Effects

    func applyVisualEffects(to view: UIView, effect: String) {
        clearVisualEffects(from: view)

        switch effect {
        case "Neon Glow":
            view.layer.shadowColor = UIColor.systemPurple.cgColor
            view.layer.shadowRadius = 8
            view.layer.shadowOpacity = 0.6
            view.layer.shadowOffset = .zero
//
//            view.layer.borderWidth = 1
//            view.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        case "Ice Chill":
            view.layer.shadowColor = UIColor.white.cgColor
            view.layer.shadowRadius = 8
            view.layer.shadowOpacity = 0.6
            view.layer.shadowOffset = CGSize.zero
        default:
            break
        }
    }

    func clearVisualEffects(from view: UIView) {
        view.layer.shadowOpacity = 0
        view.layer.shadowRadius = 0
    }
}
