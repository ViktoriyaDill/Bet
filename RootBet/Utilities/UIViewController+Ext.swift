//
//  UIViewController+Ext.swift
//  RootBet
//
//  Created by Пользователь on 12.06.2025.
//

import Foundation
import UIKit


extension UIViewController {
    func showAchievementUnlock(_ achievement: Achievement) {
        let popup = AchievementUnlockPopup(achievement: achievement)
        popup.show(in: view)
    }
}
