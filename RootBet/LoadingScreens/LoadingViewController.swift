//
//  ViewController.swift
//  RootBet
//
//  Created by Пользователь on 31.05.2025.
//

import UIKit
import SnapKit

// MARK: - Loading Screen
class LoadingViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let logoContainerView = UIView()
    private let logoImageView = UIImageView()
    private let titleImageView = UIImageView()
    private let loadingLabel = UILabel()
    private let progressView = UIProgressView()
    private let homeIndicator = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoadingAnimation()
    }
    
    private func setupUI() {
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        // Logo container with golden circle
        logoContainerView.backgroundColor = .clear
        logoContainerView.layer.cornerRadius = 60
        logoContainerView.layer.borderWidth = 8
        logoContainerView.layer.borderColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0).cgColor
        
        // Logo image
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        logoImageView.image = UIImage(named: "logo 1")
        
        // Title image
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        titleImageView.image = UIImage(named: "text")
        
        // Loading Label
        loadingLabel.text = "Loading"
        loadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        
        // Progress View
        progressView.progressTintColor = .white
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        
        // Home Indicator
        homeIndicator.backgroundColor = .white
        homeIndicator.layer.cornerRadius = 2.5
        
        // Add subviews
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        view.addSubview(titleImageView)
        view.addSubview(loadingLabel)
        view.addSubview(progressView)
        view.addSubview(homeIndicator)
    }
    
    private func setupConstraints() {
        logoContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(120)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(60)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(logoContainerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    
        
        loadingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(40)
            make.bottom.equalTo(progressView.snp.top).offset(-15)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(homeIndicator.snp.top).offset(-40)
            make.height.equalTo(4)
        }
        
        homeIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(134)
            make.height.equalTo(5)
        }
    }
    
    private func startLoadingAnimation() {
        progressView.setProgress(0.0, animated: false)
        
        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseInOut) {
            self.progressView.setProgress(1.0, animated: true)
        } completion: { _ in
            self.navigateToOnboarding()
        }
        
        // Rotate logo animation
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 2.0
        rotation.repeatCount = .infinity
        logoContainerView.layer.sublayers?.first?.add(rotation, forKey: "rotation")
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }
}

