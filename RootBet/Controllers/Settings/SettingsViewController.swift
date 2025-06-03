//
//  SettingsViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit
import StoreKit

class SettingsViewController: BaseViewController {
    
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
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    // Settings buttons
    private let personalizationButton = SettingsMenuButton(title: "PERSONALIZATION")
    private let aboutUsButton = SettingsMenuButton(title: "ABOUT US")
    private let privacyPolicyButton = SettingsMenuButton(title: "PRIVACY POLICY")
    private let shareAppButton = SettingsMenuButton(title: "SHARE APP")
    private let rateAppButton = SettingsMenuButton(title: "RATE APP")
    
    private let userService = UserDataService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        applyCurrentTheme() 
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add buttons to content view
        contentView.addSubview(personalizationButton)
        contentView.addSubview(aboutUsButton)
        contentView.addSubview(privacyPolicyButton)
        contentView.addSubview(shareAppButton)
        contentView.addSubview(rateAppButton)
    }
    
    private func setupConstraints() {
        
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
        
        // Buttons constraints
        personalizationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(70)
        }
        
        aboutUsButton.snp.makeConstraints { make in
            make.top.equalTo(personalizationButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(70)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(aboutUsButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(70)
        }
        
        shareAppButton.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(70)
        }
        
        rateAppButton.snp.makeConstraints { make in
            make.top.equalTo(shareAppButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        personalizationButton.addTarget(self, action: #selector(personalizationButtonTapped), for: .touchUpInside)
        aboutUsButton.addTarget(self, action: #selector(aboutUsButtonTapped), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTapped), for: .touchUpInside)
        shareAppButton.addTarget(self, action: #selector(shareAppButtonTapped), for: .touchUpInside)
        rateAppButton.addTarget(self, action: #selector(rateAppButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func personalizationButtonTapped() {
        let personalizationVC = PersonalizationViewController()
        navigationController?.pushViewController(personalizationVC, animated: true)
    }
    
    @objc private func aboutUsButtonTapped() {
        let aboutVC = AboutUsViewController()
        aboutVC.modalPresentationStyle = .overFullScreen
        present(aboutVC, animated: true)
    }
    
    @objc private func privacyPolicyButtonTapped() {
        let privacyVC = PrivacyPolicyViewController()
        privacyVC.modalPresentationStyle = .overFullScreen
        present(privacyVC, animated: true)
    }
    
    @objc private func shareAppButtonTapped() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out RootBet Casual Spin!"],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
    
    @objc private func rateAppButtonTapped() {
        requestAppStoreReview()
    }
    
    private func requestAppStoreReview() {
        if let windowScene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


