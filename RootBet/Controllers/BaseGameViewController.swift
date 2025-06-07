//
//  BaseGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

class BaseGameViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "BG2")
        return imageView
    }()
    
    private let scoreView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#4E4A8D")
        v.layer.cornerRadius = 6
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let timeView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#4E4A8D")
        v.layer.cornerRadius = 6
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    
    // MARK: - Header
    
    let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prevBtn"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    private let roundView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.spacing = 4
        v.alignment = .center
        v.distribution = .fillEqually
        v.backgroundColor = UIColor(hex: "#4E4A8D")
        v.layer.cornerRadius = 6
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        return v
    }()
    
    let roundLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let roundImage: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "Flame")
        return i
    }()
    
    
    private let coinContainer: UIView = {
        let c = UIView()
        c.backgroundColor = UIColor(red: 0.85, green: 0.82, blue: 1.00, alpha: 1.00)
        c.layer.cornerRadius = 6
        c.clipsToBounds = true
        return c
    }()
    
    private let coinIcon: UIImageView = {
        let ci = UIImageView()
        ci.contentMode = .scaleAspectFit
        ci.image = UIImage(named: "gold-coin")
        return ci
    }()
    
    let coinsLabel: UILabel = {
        let c = UILabel()
        c.font = UIFont.sigmarOne(16)
        c.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        c.text = "0"
        return c
    }()
    
    private let infoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "infoBtn"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    // MARK: - Footer (Play/Spin/Stop)
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(hex: "#A77BCA")
        button.layer.cornerRadius = 25
        return button
    }()
    
    var gameType: GameType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGameType()
        
        setupBaseUI()
        setupBaseConstraints()
        setupBaseActions()
    }
    
    func setupBaseUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(backButton)
        
        view.addSubview(timeView)
        timeView.addSubview(timeLabel)
        
        view.addSubview(scoreView)
        scoreView.addSubview(scoreLabel)
        
        view.addSubview(roundView)
        roundView.addArrangedSubview(roundImage)
        roundView.addArrangedSubview(roundLabel)
        
        view.addSubview(coinContainer)
        coinContainer.addSubview(coinIcon)
        coinContainer.addSubview(coinsLabel)
        
        view.addSubview(infoButton)
        view.addSubview(playButton)
    }
    
    func setupBaseConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Header
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }
        
        roundView.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalTo(backButton.snp.trailing).offset(30)
            make.width.equalTo(72)
            make.height.equalTo(48)
        }
         
        roundImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.height.width.equalTo(24)
        }
        
        coinContainer.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.leading.equalTo(roundView.snp.trailing).offset(30)
            make.width.equalTo(100)
            make.height.equalTo(48)
        }
        
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
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }
        
        // score & time
        
        scoreView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(80)
            make.height.equalTo(32)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timeView.snp.makeConstraints { make in
            make.top.equalTo(infoButton.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(80)
            make.height.equalTo(32)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // Footer
        
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
    }
    
    func setupBaseActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        HapticManager.shared.lightTap()
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func infoButtonTapped() {
        let infoVC = InfoViewController()
        infoVC.gameType = .colorSpin
        infoVC.modalPresentationStyle = .fullScreen
        present(infoVC, animated: true)
    }
    
    @objc func playButtonTapped() {
        HapticManager.shared.mediumTap()
    }

    
    private func configureGameType() {
        guard let type = self.gameType else { return }
        
        switch type {
        case .colorSpin:
            timeView.isHidden = true
            scoreView.isHidden = true
            roundImage.isHidden = true
            roundLabel.textAlignment = .center
        case .stackTower:
            timeView.isHidden = false
            scoreView.isHidden = false
            roundImage.isHidden = false
            roundLabel.textAlignment = .left
        case .bubbleCatch:
            timeView.isHidden = false
            scoreView.isHidden = false
            roundImage.isHidden = false
            roundLabel.textAlignment = .left
        case .memoryMatch:
            timeView.isHidden = true
            scoreView.isHidden = true
            roundImage.isHidden = true
            roundLabel.textAlignment = .center
        }
    }
}
