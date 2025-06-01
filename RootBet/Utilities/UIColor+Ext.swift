//
//  UIColor+Ext.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
