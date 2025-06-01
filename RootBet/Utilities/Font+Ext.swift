//
//  Font+Ext.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit

enum FontWeight {
    case regular
    
    var name: String {
        switch self {
        case .regular:
            return "SigmarOne-Regular"
        }
    }
}

extension UIFont {
    static func sigmarOne(_ size: CGFloat = 16, weigth: FontWeight = .regular) -> UIFont? {
        return UIFont(name: weigth.name, size: size)
    }
}

