//
//  AchievementUnlockPopup.swift
//  RootBet
//
//  Created by Пользователь on 12.06.2025.
//

import UIKit
import SnapKit

class AchievementUnlockPopup: UIView {
    
    // MARK: - Properties
    private let achievement: Achievement
    private var onDismiss: (() -> Void)?
    
    // MARK: - UI Elements
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    private let containerView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Win")
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    private let congratulationsLabel: UILabel = {
        let label = UILabel()
        label.text = "CONGRATULATIONS!"
        label.font = UIFont.sigmarOne(20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You've just earned a new\nachievement"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let achievementNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sigmarOne(32)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let particleEmitter = CAEmitterLayer()
    
    // MARK: - Initialization
    init(achievement: Achievement, onDismiss: (() -> Void)? = nil) {
        self.achievement = achievement
        self.onDismiss = onDismiss
        super.init(frame: .zero)
        setupUI()
        setupParticles()
        configureAchievement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(containerView)
        
        containerView.addSubview(closeButton)
        containerView.addSubview(congratulationsLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(achievementNameLabel)
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
        
        congratulationsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(congratulationsLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        achievementNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func configureAchievement() {
        achievementNameLabel.text = achievement.title.uppercased()
    }
    
    private func setupParticles() {
        particleEmitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 3.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionRange = .pi
        cell.scale = 0.3
        cell.scaleRange = 0.2
        cell.contents = UIImage(systemName: "star.fill")?.cgImage
        cell.color = UIColor.systemYellow.cgColor
        cell.alphaSpeed = -0.3
        cell.spin = 2.0
        cell.spinRange = 1.0
        
        particleEmitter.emitterCells = [cell]
        layer.addSublayer(particleEmitter)
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss()
    }
    
    @objc private func backgroundTapped() {
        dismiss()
    }
    
    // MARK: - Animation Methods
    func show(in parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Initial state
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        backgroundView.alpha = 0
        
        // Animate in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
            self.backgroundView.alpha = 1
        }) { _ in
            // Start particle animation
            self.startParticleAnimation()
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            self.onDismiss?()
        }
    }
    
    private func startParticleAnimation() {
        particleEmitter.birthRate = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.particleEmitter.birthRate = 0
        }
    }
    
}
