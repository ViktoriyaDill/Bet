//
//  SettingsMenuButton.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import Foundation
import UIKit
import SnapKit

class SettingsMenuButton: UIButton {
    
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLbl.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(40)
        }
    }
}
