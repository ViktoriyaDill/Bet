//
//  BonusViewController.swift
//  RootBet
//
//  Created by Пользователь on 10.06.2025.
//

import UIKit
import SnapKit
import RealmSwift


class BonusViewController: BaseViewController {

     private var coinLabel = UILabel()
     private var crystalLabel = UILabel()
    
    private let userService = UserDataService.shared
    
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prevBtn"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Bonus"
        lbl.font = UIFont.sigmarOne(32)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let headerView: UIView = {
        let stack = UIView()
        stack.backgroundColor = .clear
        return stack
    }()
    
    private let menuButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        setupConstraints()
        setupActions()
        createHeaderView()
        loadHeaderData()
        applyCurrentTheme()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAvatarDisplay), name: .avatarDidChange, object: nil)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .avatarDidChange, object: nil)
    }

    
    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(titleLabel)
        view.addSubview(menuButtonsStackView)
        
        setupMenuButtons()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func createHeaderView() {
        
        headerView.addSubview(backButton)
        
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
        coinsLabel.font = UIFont.sigmarOne(16)
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
        crystalsLabel.font = UIFont.sigmarOne(16)
        crystalsLabel.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        crystalContainer.addSubview(crystalsLabel)
        self.crystalLabel = crystalsLabel
        headerView.addSubview(coinContainer)
        headerView.addSubview(crystalContainer)
        
        // 1) Avatar
        
        backButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
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
            make.height.equalTo(coinContainer.snp.width).multipliedBy(0.48)
            make.width.equalToSuperview().multipliedBy(0.28)
            make.trailing.equalToSuperview()
        }
        
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
            make.trailing.equalTo(crystalContainer.snp.leading).offset(-6)
            make.height.equalTo(coinContainer.snp.width).multipliedBy(0.48)
            make.width.equalToSuperview().multipliedBy(0.28)
        }
    }
      
    private func setupMenuButtons() {
        let buttonsTypes: [BonusButtonModel] = [.daily, .spin, .challenges, .achievements]
        for (index, buttonType) in buttonsTypes.enumerated() {
            let button = createMenuButton(for: buttonType)
            button.tag = index
            menuButtonsStackView.addArrangedSubview(button)
        }
    }

    
    private func createMenuButton(for buttonType: BonusButtonModel) -> UIView {
        let view = UIView()
        
        let title = UILabel()
        title.text = buttonType.rawValue
        title.font = UIFont.sigmarOne(16)
        title.numberOfLines = 2
        title.textColor = .white
        title.textAlignment = .left
        view.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(40)
            make.height.equalTo(38)
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: buttonType.imageName)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        view.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        
        
        return view
    }
    
    private func setupConstraints() {
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(30)
        }
        
        menuButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.6)
        }

    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func loadHeaderData() {
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
        
        guard index >= 0, index < BonusButtonModel.allCases.count else { return }
        let model = BonusButtonModel.allCases[index]
        
        switch model {
        case .daily:
            HapticManager.shared.mediumTap()
            let detailVC = DailyBonusViewController()
            navigationController?.pushViewController(detailVC, animated: true)
            
        case .spin:
            HapticManager.shared.mediumTap()
             let bonusVC = SpinWheelViewController()
            navigationController?.pushViewController(bonusVC, animated: true)
            
        case .challenges:
            HapticManager.shared.lightTap()
            let challengeVC = DailyChallengesViewController()
            navigationController?.pushViewController(challengeVC, animated: false)
        case .achievements:
            HapticManager.shared.lightTap()
        }
    }

    
    override func applyThemeToElements(theme: String, effects: String) {
           super.applyThemeToElements(theme: theme, effects: effects)
           
           let buttonContainers = menuButtonsStackView.arrangedSubviews
           for container in buttonContainers {
               themeManager.applyVisualEffects(to: container, effect: effects)
           }
           updateCurrencyContainersTheme(theme: theme)
       }
       
       private func updateCurrencyContainersTheme(theme: String) {
           let coinContainerColor: UIColor
           let textColor: UIColor
           
           switch theme {
           case "Light Mode":
               coinContainerColor = UIColor(red: 0.75, green: 0.72, blue: 0.90, alpha: 1.00)
               textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
           case "Classic Mode":
               coinContainerColor = UIColor(red: 0.40, green: 0.45, blue: 0.55, alpha: 1.00)
               textColor = UIColor.white
           default: // Dark Mode
               coinContainerColor = UIColor(red: 0.85, green: 0.82, blue: 1.00, alpha: 1.00)
               textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
           }
       }

}
