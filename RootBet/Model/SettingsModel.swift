//
//  SettingsModel.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import Foundation
import UIKit


struct SettingsItem {
    let id: String
    let title: String
    let icon: String
    let type: SettingsItemType
    var value: Any?
}

enum SettingsItemType {
    case navigation
    case toggle
    case selection
    case avatar
    case colorPicker
}
