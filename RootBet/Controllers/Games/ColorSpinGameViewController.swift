//
//  ColorSpinGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import SnapKit

class ColorSpinGameViewController: BaseGameViewController {
    
    private let viewModel = ColorSpinViewModel()
    
    private let wheelView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let targetColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = .red
        return view
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "Target Color"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let spinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SPIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 40
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColorSpinUI()
        setupColorSpinConstraints()
        setupColorSpinActions()
        bindViewModel()
    }
    
    private func setupColorSpinUI() {
        view.addSubview(wheelView)
        view.addSubview(targetColorView)
        view.addSubview(targetLabel)
        view.addSubview(spinButton)
        
        drawSpinWheel()
    }
    
    private func setupColorSpinConstraints() {
        wheelView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(250)
        }
        
        targetColorView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        targetLabel.snp.makeConstraints { make in
            make.top.equalTo(targetColorView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        spinButton.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
    
    private func setupColorSpinActions() {
        spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    private func drawSpinWheel() {
        let colors: [UIColor] = [.red, .blue, .green, .yellow, .orange, .purple, .cyan, .magenta]
        let center = CGPoint(x: 125, y: 125)
        let radius: CGFloat = 100
        let anglePerSection = 2 * CGFloat.pi / CGFloat(colors.count)
        
        for (index, color) in colors.enumerated() {
            let path = UIBezierPath()
            path.move(to: center)
            
            let startAngle = CGFloat(index) * anglePerSection
            let endAngle = CGFloat(index + 1) * anglePerSection
            
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = color.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 2
            
            wheelView.layer.addSublayer(shapeLayer)
        }
    }
    
    @objc private func spinButtonTapped() {
        viewModel.spinWheel()
        
        // Animate wheel spin
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 4 + CGFloat.random(in: 0...(CGFloat.pi * 2))
        rotation.duration = 2.0
        rotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        wheelView.layer.add(rotation, forKey: "spinAnimation")
    }
    
    override func startButtonTapped() {
        super.startButtonTapped()
        viewModel.startGame()
        startButton.setTitle("Game Active", for: .normal)
        startButton.backgroundColor = .systemGray
        startButton.isEnabled = false
    }
}

extension ColorSpinGameViewController: GameViewModelDelegate {
    func gameDidStart() {
        // Update UI for game start
    }
    
    func gameDidEnd(score: Int) {
        startButton.setTitle("Start Game", for: .normal)
        startButton.backgroundColor = .systemGreen
        startButton.isEnabled = true
        
        let alert = UIAlertController(title: "Game Over", message: "Final Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func scoreDidUpdate(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}
