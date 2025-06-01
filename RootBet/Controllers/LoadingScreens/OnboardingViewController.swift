//
//  OnboardingViewController.swift
//  RootBet
//
//  Created by Пользователь on 31.05.2025.
//

import UIKit
import SnapKit

// MARK: - Supporting Models
struct OnboardingData {
    let title: String
    let description: String
    let imageName: String
}



class OnboardingViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let characterImageView = UIImageView()
    private let pageControl = UIPageControl()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let nextButton = UIButton()
    private let contentStackView = UIStackView()
    
    private var currentPage = 0 {
        didSet {
            updateContent()
        }
    }
    
    private let onboardingData = [
        OnboardingData(
            title: "Welcome To Roobet Casual Spin!",
            description: "Get ready for an exciting collection of fun and addictive mini-games that will test your skills, timing, and memory.",
            imageName: "beautiful-woman-in-purple-dress 1"
        ),
        OnboardingData(
            title: "More Games, More Fun!",
            description: "Play daily to earn rewards and challenge yourself with new exciting levels.\nReady to spin, stack, and match your way to victory?",
            imageName: "beautiful-woman-in-purple-dress 1"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateContent()
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
        // Background Image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        // Character Image
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        
        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Description Label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        // Page Control
        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        
        // Next Button
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        nextButton.layer.cornerRadius = 4
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        // Content Stack View
        contentStackView.axis = .horizontal
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 0
        
        // Add subviews
        view.addSubview(backgroundImageView)
        view.addSubview(characterImageView)
        view.addSubview(pageControl)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        characterImageView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(112)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(characterImageView.snp.top).offset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(56)
            make.width.equalTo(88)
        }
    }
    
    
    private func updateContent() {
        let data = onboardingData[currentPage]
        
        // Update content with animation
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve) {
            self.titleLabel.text = data.title
            self.descriptionLabel.text = data.description
            self.characterImageView.image = UIImage(named: data.imageName)
        }
        
        pageControl.currentPage = currentPage
    }
    
    @objc private func pageControlChanged() {
        currentPage = pageControl.currentPage
    }
    
    @objc private func nextButtonTapped() {
        if currentPage < onboardingData.count - 1 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        navigateToMainApp()
    }
    
    private func navigateToMainApp() {
        let mainMenuVC = MainMenuViewController()
        navigationController?.pushViewController(mainMenuVC, animated: false)
        let navigationController = UINavigationController(rootViewController: mainMenuVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.rootViewController = navigationController
            }
        }
    }
}

// MARK: - Extensions

extension UILabel {
    var letterSpacing: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpacing = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpacing
            } else {
                return 0
            }
        }
    }
}
