//
//  SettingsActionButton.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import Foundation
import UIKit


class SettingsActionButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.sigmarOne(16)
        backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
}
