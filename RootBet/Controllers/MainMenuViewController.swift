//
//  MainMenuViewController.swift
//  RootBet
//
//  Created by Пользователь on 31.05.2025.
//

import UIKit
import SnapKit

class MainMenuViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
            return imageView
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Gaming Hub"
            label.font = UIFont.boldSystemFont(ofSize: 32)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        private let gameButtonsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        private let settingsButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Settings", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
            button.layer.cornerRadius = 12
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupConstraints()
            setupActions()
        }
        
        private func setupUI() {
            view.addSubview(backgroundImageView)
            view.addSubview(titleLabel)
            view.addSubview(gameButtonsStackView)
            view.addSubview(settingsButton)
            
            setupGameButtons()
        }
        
        private func setupGameButtons() {
            let gameTypes: [GameType] = [.colorSpin, .stackTower, .bubbleCatch, .memoryMatch]
            
            for gameType in gameTypes {
                let button = createGameButton(for: gameType)
                gameButtonsStackView.addArrangedSubview(button)
            }
        }
        
        private func createGameButton(for gameType: GameType) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(gameType.rawValue, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
            button.layer.cornerRadius = 16
            button.tag = gameType.hashValue
            
            // Add gradient background
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor.systemPurple.cgColor,
                UIColor.systemBlue.cgColor
            ]
            gradientLayer.cornerRadius = 16
            button.layer.insertSublayer(gradientLayer, at: 0)
            
            return button
        }
        
        private func setupConstraints() {
            backgroundImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
                make.centerX.equalToSuperview()
            }
            
            gameButtonsStackView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(40)
                make.height.equalTo(320)
            }
            
            settingsButton.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
                make.centerX.equalToSuperview()
                make.width.equalTo(120)
                make.height.equalTo(44)
            }
        }
        
        private func setupActions() {
            settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
            
            for button in gameButtonsStackView.arrangedSubviews {
                if let gameButton = button as? UIButton {
                    gameButton.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
                }
            }
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            // Update gradient frames
            for subview in gameButtonsStackView.arrangedSubviews {
                if let button = subview as? UIButton,
                   let gradientLayer = button.layer.sublayers?.first as? CAGradientLayer {
                    gradientLayer.frame = button.bounds
                }
            }
        }
        
        @objc private func gameButtonTapped(_ sender: UIButton) {
            HapticManager.shared.impact(.medium)
            
            let gameTypes: [GameType] = [.colorSpin, .stackTower, .bubbleCatch, .memoryMatch]
            let gameType = gameTypes[sender.tag % gameTypes.count]
            
            let gameVC = createGameViewController(for: gameType)
            gameVC.modalPresentationStyle = .fullScreen
            present(gameVC, animated: true)
        }
        
        private func createGameViewController(for gameType: GameType) -> UIViewController {
            switch gameType {
            case .colorSpin:
                return ColorSpinGameViewController()
            case .stackTower:
                return StackTowerGameViewController()
            case .bubbleCatch:
                return BubbleCatchGameViewController()
            case .memoryMatch:
                return MemoryMatchGameViewController()
            }
        }
        
        @objc private func settingsButtonTapped() {
            HapticManager.shared.impact(.light)
            let settingsVC = SettingsViewController()
            let navController = UINavigationController(rootViewController: settingsVC)
            present(navController, animated: true)
        }
    }
