//
//  UIColor+Ext.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
           var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
           hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
           var rgb: UInt64 = 0
           Scanner(string: hexSanitized).scanHexInt64(&rgb)

           let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
           let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
           let b = CGFloat(rgb & 0x0000FF) / 255
           self.init(red: r, green: g, blue: b, alpha: 1)
       }

       func toHexString() -> String {
           guard let components = cgColor.components, components.count >= 3 else { return "#000000" }
           let r = Int(components[0] * 255)
           let g = Int(components[1] * 255)
           let b = Int(components[2] * 255)
           return String(format: "#%02X%02X%02X", r, g, b)
       }
    
    static func random() -> UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
