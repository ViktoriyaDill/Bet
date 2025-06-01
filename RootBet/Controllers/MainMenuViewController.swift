//
//  MainMenuViewController.swift
//  RootBet
//
//  Created by Пользователь on 31.05.2025.
//

import UIKit
import SnapKit
import RealmSwift

class MainMenuViewController: UIViewController {
    
    private var avatarImageView = UIImageView()
     private var coinLabel = UILabel()
     private var crystalLabel = UILabel()
    
    private let userService = UserDataService.shared
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG 1")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        return imageView
    }()
    
    private let headerView: UIView = {
        let stack = UIView()
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let menuButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        createHeaderView()
        loadHeaderData()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerView)
        view.addSubview(menuButtonsStackView)
        
        setupMenuButtons()
    }
    
    private func createHeaderView() {
        
        let avatar = UIImageView()
        avatar.contentMode = .scaleAspectFit
        avatar.clipsToBounds = true
        headerView.addSubview(avatar)
        
      
        let coinContainer = UIView()
        coinContainer.backgroundColor = UIColor(red: 0.85, green: 0.82, blue: 1.00, alpha: 1.00)
        coinContainer.layer.cornerRadius = 6
        coinContainer.clipsToBounds = true
        headerView.addSubview(coinContainer)
        
        let coinIcon = UIImageView()
        coinIcon.contentMode = .scaleAspectFit
        coinIcon.image = UIImage(named: "gold-coin")
        coinContainer.addSubview(coinIcon)
        
        let coinsLabel = UILabel()
        coinsLabel.font = UIFont.sigmarOne(20)
        coinsLabel.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        coinContainer.addSubview(coinsLabel)
        self.coinLabel = coinsLabel
        
        
        let crystalContainer = UIView()
        crystalContainer.backgroundColor = UIColor(red: 0.85, green: 0.82, blue: 1.00, alpha: 1.00)
        crystalContainer.layer.cornerRadius = 6
        crystalContainer.clipsToBounds = true
        headerView.addSubview(crystalContainer)
        
        let crystalIcon = UIImageView()
        crystalIcon.contentMode = .scaleAspectFit
        crystalIcon.image = UIImage(named: "diam-coin")
        crystalContainer.addSubview(crystalIcon)
        
        let crystalsLabel = UILabel()
        crystalsLabel.font = UIFont.sigmarOne(20)
        crystalsLabel.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        crystalContainer.addSubview(crystalsLabel)
        self.crystalLabel = crystalsLabel
        
        headerView.addSubview(avatar)
        headerView.addSubview(coinContainer)
        headerView.addSubview(crystalContainer)

        // 1) Avatar
        avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(avatar.snp.height)
        }
        self.avatarImageView = avatar

        // 2) Coin Container
        coinIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(coinIcon.snp.width)
        }
        coinsLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(6)
        }
        coinContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatar.snp.trailing).offset(44)
            make.height.equalTo(coinContainer.snp.width).multipliedBy(0.48)
            make.width.equalToSuperview().multipliedBy(0.28)
        }

        // 3) Crystal Container
        crystalIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(crystalIcon.snp.width)
        }
        crystalsLabel.snp.makeConstraints { make in
            make.leading.equalTo(crystalIcon.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(6)
        }
        crystalContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(coinContainer.snp.trailing).offset(6)
            make.height.equalTo(coinContainer.snp.width).multipliedBy(0.48)
            make.width.equalToSuperview().multipliedBy(0.28)
            make.trailing.equalToSuperview()
        }
    }
      
    private func setupMenuButtons() {
        let buttonsTypes: [MenuButtonModel] = [.game, .bonus, .settings]
        for (index, buttonType) in buttonsTypes.enumerated() {
            let button = createMenuButton(for: buttonType)
            button.tag = index
            menuButtonsStackView.addArrangedSubview(button)
        }
    }

    
    private func createMenuButton(for buttonType: MenuButtonModel) -> UIView {
        let view = UIView()
        
        let title = UILabel()
        title.text = buttonType.rawValue
        title.font = UIFont.sigmarOne(32)
        title.textColor = .white
        title.textAlignment = .left
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(40)
            make.height.equalToSuperview().multipliedBy(0.32)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: buttonType.imageName)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalToSuperview()
        }
        
        view.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        
        
        return view
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        menuButtonsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(320)
        }

    }
    
    private func loadHeaderData() {
           // 1) Avatar
           let avatarName = userService.avatarImageName
           if let image = UIImage(named: avatarName) {
               avatarImageView.image = image
           } else {
               avatarImageView.image = UIImage(named: "photoUser")
           }

           // 2) Coins
           let coinsCount = userService.coins
           coinLabel.text = "\(coinsCount)"

           // 3) Crystals
           let crystalsCount = userService.crystals
           crystalLabel.text = "\(crystalsCount)"
       }
    
    private func setupActions() {
          for subview in menuButtonsStackView.arrangedSubviews {
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped(_:)))
              subview.addGestureRecognizer(tapGesture)
              subview.isUserInteractionEnabled = true
          }
      }
    
    
    @objc private func menuButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let container = sender.view else { return }
        let index = container.tag
        
        guard index >= 0, index < MenuButtonModel.allCases.count else { return }
        let model = MenuButtonModel.allCases[index]
        
        switch model {
        case .game:
            HapticManager.shared.impact(.medium)
            let detailVC = GameDetailViewController(startIndex: index)
            navigationController?.pushViewController(detailVC, animated: true)
            
        case .bonus:
            HapticManager.shared.impact(.medium)
            // let bonusVC = createGameViewController(for: .stackTower)
            // bonusVC.modalPresentationStyle = .fullScreen
            // present(bonusVC, animated: true)
            
        case .settings:
            HapticManager.shared.impact(.light)
            let settingsVC = SettingsViewController()
            navigationController?.pushViewController(settingsVC, animated: false)
        }
    }

    
//    @objc private func gameButtonTapped(_ sender: UIButton) {
//        HapticManager.shared.impact(.medium)
//        
//        let gameTypes: [GameType] = [.colorSpin, .stackTower, .bubbleCatch, .memoryMatch]
//        let gameType = gameTypes[sender.tag % gameTypes.count]
//        
//        let gameVC = createGameViewController(for: gameType)
//        gameVC.modalPresentationStyle = .fullScreen
//        present(gameVC, animated: true)
//    }
    
//    private func createGameViewController(for gameType: GameType) -> UIViewController {
//        switch gameType {
//        case .colorSpin:
//            return ColorSpinGameViewController()
//        case .stackTower:
//            return StackTowerGameViewController()
//        case .bubbleCatch:
//            return BubbleCatchGameViewController()
//        case .memoryMatch:
//            return MemoryMatchGameViewController()
//        }
//    }
    
//    @objc private func settingsButtonTapped() {
//        HapticManager.shared.impact(.light)
//        let settingsVC = SettingsViewController()
//        let navController = UINavigationController(rootViewController: settingsVC)
//        present(navController, animated: true)
//    }
}
