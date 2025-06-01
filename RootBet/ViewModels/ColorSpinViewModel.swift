//
//  ColorSpinViewModel.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import RealmSwift



class ColorSpinViewModel: BaseGameViewModel {
    override var gameType: GameType { .colorSpin }
    
    @Published var spinItems: [ColorSpinItem] = []
    @Published var targetColor: UIColor = .red
    @Published var isSpinning: Bool = false
    
    private let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange, .purple, .cyan, .magenta]
    
    override func startGame() {
        setupSpinWheel()
        generateTargetColor()
        super.startGame()
    }
    
    private func setupSpinWheel() {
        spinItems = colors.enumerated().map { index, color in
            ColorSpinItem(color: color, points: (index + 1) * 10)
        }
    }
    
    private func generateTargetColor() {
        targetColor = colors.randomElement() ?? .red
    }
    
    func spinWheel() {
        guard isGameActive, !isSpinning else { return }
        
        isSpinning = true
        HapticManager.shared.impact(.medium)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isSpinning = false
            self.checkResult()
        }
    }
    
    private func checkResult() {
        let selectedColor = spinItems.randomElement()?.color ?? .red
        if selectedColor == targetColor {
            let points = spinItems.first(where: { $0.color == selectedColor })?.points ?? 0
            updateScore(score + points)
            HapticManager.shared.notification(.success)
        } else {
            HapticManager.shared.notification(.error)
        }
        generateTargetColor()
    }
}
