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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoadingAnimation()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        
        // Background image
        backgroundImageView.image = UIImage(named: "BG 1")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
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
        
        // Add subviews
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        logoContainerView.addSubview(titleImageView)
        view.addSubview(loadingLabel)
        view.addSubview(progressView)
    }
    
    private func setupConstraints() {
        logoContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.84)
            make.height.equalToSuperview().multipliedBy(0.43)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(0.6)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).inset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.52)
        }
        
        
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressView.snp.top).offset(-16)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(4)
        }
    }
    
    private func startLoadingAnimation() {
        progressView.setProgress(0.0, animated: false)
        
        // Animate progress with timer for smooth increments
        var currentProgress: Float = 0.0
        let progressIncrement: Float = 0.01
        let animationDuration: TimeInterval = 3.0
        let timerInterval = animationDuration / Double(1.0 / progressIncrement)
        
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            currentProgress += progressIncrement
            
            DispatchQueue.main.async {
                self.progressView.setProgress(currentProgress, animated: true)
                
                // Check if loading is complete
                if currentProgress >= 1.0 {
                    timer.invalidate()
                    
                    // Small delay before navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.checkIfShouldShowOnboarding()
                    }
                }
            }
            
        }
    }
    
    private func checkIfShouldShowOnboarding() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if hasCompletedOnboarding {
            navigateToMainMenu()
        } else {
            navigateToOnboarding()
        }
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }
    
    private func navigateToMainMenu() {
        let mainMenuVC = MainMenuViewController()
        let navigationController = UINavigationController(rootViewController: mainMenuVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navigationController
            }
        }
    }
}

