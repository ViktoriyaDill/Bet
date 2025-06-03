//
//  PersonalizationViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

class PersonalizationViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG 1")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        return imageView
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prevBtn"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "SETTINGS"
        lbl.font = UIFont.sigmarOne(32)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let personalizationLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "PERSONALIZATION"
        lbl.font = UIFont.sigmarOne(24)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    // Personalization options
    private let avatarButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        return btn
    }()
    
    private let avatarLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AVATAR"
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let themeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        return btn
    }()
    
    private let themeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "THEME"
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let themeValueContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let themeLeftArrow: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.left")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let themeValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Dark Mode"
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let themeRightArrow: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let visualEffectsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.white.cgColor
        return btn
    }()
    
    private let visualEffectsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VISUAL EFFECTS"
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let effectsValueContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let effectsLeftArrow: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.left")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let effectsValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No"
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let effectsRightArrow: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // Sound and Vibro switches
    private let soundLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "SOUND"
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let soundSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = UIColor(red: 0.48, green: 0.03, blue: 0.83, alpha: 1.00)
        return sw
    }()
    
    private let vibroLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VIBRO"
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = .white
        return lbl
    }()
    
    private let vibroSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = UIColor(red: 0.48, green: 0.03, blue: 0.83, alpha: 1.00)
        return sw
    }()
    
    private let userService = UserDataService.shared
    private var currentThemeIndex = 0
    private var currentEffectIndex = 0
    
    private let themes = ["Dark Mode", "Light Mode", "Classic Mode"]
    private let effects = ["No", "Neon Glow", "Ice Crystals"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        loadSettings()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        
        view.addSubview(backgroundImageView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add personalization section
        contentView.addSubview(personalizationLabel)
        contentView.addSubview(avatarButton)
        avatarButton.addSubview(avatarLabel)
        
        contentView.addSubview(themeButton)
        themeButton.addSubview(themeLabel)
        themeButton.addSubview(themeValueContainer)
        themeValueContainer.addSubview(themeLeftArrow)
        themeValueContainer.addSubview(themeValueLabel)
        themeValueContainer.addSubview(themeRightArrow)
        
        contentView.addSubview(visualEffectsButton)
        visualEffectsButton.addSubview(visualEffectsLabel)
        visualEffectsButton.addSubview(effectsValueContainer)
        effectsValueContainer.addSubview(effectsLeftArrow)
        effectsValueContainer.addSubview(effectsValueLabel)
        effectsValueContainer.addSubview(effectsRightArrow)
        
        // Add sound and vibro controls
        contentView.addSubview(soundLabel)
        contentView.addSubview(soundSwitch)
        contentView.addSubview(vibroLabel)
        contentView.addSubview(vibroSwitch)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // Personalization section
        personalizationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(32)
        }
        
        avatarButton.snp.makeConstraints { make in
            make.top.equalTo(personalizationLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(60)
        }
        
        avatarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        themeButton.snp.makeConstraints { make in
            make.top.equalTo(avatarButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(60)
        }
        
        themeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        themeValueContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        themeLeftArrow.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        themeValueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        themeRightArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        visualEffectsButton.snp.makeConstraints { make in
            make.top.equalTo(themeButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(60)
        }
        
        visualEffectsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        effectsValueContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        effectsLeftArrow.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        effectsValueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        effectsRightArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        // Sound and Vibro
        soundLabel.snp.makeConstraints { make in
            make.top.equalTo(visualEffectsButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(32)
        }
        
        soundSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(soundLabel)
            make.trailing.equalToSuperview().inset(32)
        }
        
        vibroLabel.snp.makeConstraints { make in
            make.top.equalTo(soundLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        vibroSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(vibroLabel)
            make.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        avatarButton.addTarget(self, action: #selector(avatarButtonTapped), for: .touchUpInside)
        
        themeButton.addTarget(self, action: #selector(themeButtonTapped), for: .touchUpInside)
        visualEffectsButton.addTarget(self, action: #selector(effectsButtonTapped), for: .touchUpInside)
        
        soundSwitch.addTarget(self, action: #selector(soundSwitchChanged), for: .valueChanged)
        vibroSwitch.addTarget(self, action: #selector(vibroSwitchChanged), for: .valueChanged)
        
        // Add tap gestures for arrows
        let themeLeftTap = UITapGestureRecognizer(target: self, action: #selector(themeLeftTapped))
        themeLeftArrow.addGestureRecognizer(themeLeftTap)
        themeLeftArrow.isUserInteractionEnabled = true
        
        let themeRightTap = UITapGestureRecognizer(target: self, action: #selector(themeRightTapped))
        themeRightArrow.addGestureRecognizer(themeRightTap)
        themeRightArrow.isUserInteractionEnabled = true
        
        let effectsLeftTap = UITapGestureRecognizer(target: self, action: #selector(effectsLeftTapped))
        effectsLeftArrow.addGestureRecognizer(effectsLeftTap)
        effectsLeftArrow.isUserInteractionEnabled = true
        
        let effectsRightTap = UITapGestureRecognizer(target: self, action: #selector(effectsRightTapped))
        effectsRightArrow.addGestureRecognizer(effectsRightTap)
        effectsRightArrow.isUserInteractionEnabled = true
    }
    
    private func loadSettings() {
        // Load current theme
        let currentTheme = userService.currentTheme
        if let themeIndex = themes.firstIndex(of: currentTheme) {
            currentThemeIndex = themeIndex
            themeValueLabel.text = themes[currentThemeIndex]
        }
        
        // Load current effects
        let currentEffects = userService.visualEffects
        if currentEffects == "No Effects" {
            currentEffectIndex = 0
            effectsValueLabel.text = "No"
        } else if let effectIndex = effects.firstIndex(of: currentEffects) {
            currentEffectIndex = effectIndex
            effectsValueLabel.text = effects[currentEffectIndex]
        }
        
        // Load switches state
        soundSwitch.isOn = userService.soundEnabled
        vibroSwitch.isOn = userService.hapticEnabled
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func avatarButtonTapped() {
        let avatarVC = AvatarSelectionViewController()
        avatarVC.delegate = self
        let navController = UINavigationController(rootViewController: avatarVC)
        present(navController, animated: true)
    }
    
    @objc private func themeButtonTapped() {
        // Could open full theme selection if needed
    }
    
    @objc private func effectsButtonTapped() {
        // Could open full effects selection if needed
    }
    
    @objc private func themeLeftTapped() {
        currentThemeIndex = (currentThemeIndex - 1 + themes.count) % themes.count
        updateTheme()
    }
    
    @objc private func themeRightTapped() {
        currentThemeIndex = (currentThemeIndex + 1) % themes.count
        updateTheme()
    }
    
    @objc private func effectsLeftTapped() {
        currentEffectIndex = (currentEffectIndex - 1 + effects.count) % effects.count
        updateEffects()
    }
    
    @objc private func effectsRightTapped() {
        currentEffectIndex = (currentEffectIndex + 1) % effects.count
        updateEffects()
    }
    
    @objc private func soundSwitchChanged() {
        userService.soundEnabled = soundSwitch.isOn
    }
    
    @objc private func vibroSwitchChanged() {
        userService.hapticEnabled = vibroSwitch.isOn
    }
    
    private func updateTheme() {
        let selectedTheme = themes[currentThemeIndex]
        themeValueLabel.text = selectedTheme
        userService.currentTheme = selectedTheme
    }
    
    private func updateEffects() {
        let selectedEffect = effects[currentEffectIndex]
        effectsValueLabel.text = selectedEffect
        
        // Convert "No" to "No Effects" for storage
        let effectToStore = selectedEffect == "No" ? "No Effects" : selectedEffect
        userService.visualEffects = effectToStore
    }
}

// MARK: - AvatarSelectionDelegate
extension PersonalizationViewController: AvatarSelectionDelegate {
    func didSelectAvatar(_ avatarName: String) {
        userService.avatarImageName = avatarName
    }
}
