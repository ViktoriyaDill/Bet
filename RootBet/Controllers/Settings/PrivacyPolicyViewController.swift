//
//  PrivacyPolicyViewController.swift
//  RootBet
//
//  Created by Пользователь on 03.06.2025.
//

import UIKit
import SnapKit

class PrivacyPolicyViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG 1")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "PRIVACY POLICY"
        lbl.font = UIFont.sigmarOne(24)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.text = """
        Privacy Policy for RootBet Casual Spin
        
        Last updated: January 2025
        
        1. INFORMATION WE COLLECT
        
        We collect information you provide directly to us:
        • Game preferences and settings
        • Avatar selection and customizations
        • Game scores and achievements
        
        We automatically collect certain information:
        • Device information (model, OS version)
        • Game usage statistics
        • Performance and crash data
        
        2. HOW WE USE YOUR INFORMATION
        
        We use the information we collect to:
        • Provide and maintain our game services
        • Improve game performance and user experience
        • Save your game progress and preferences
        • Provide customer support
        
        3. INFORMATION SHARING
        
        We do not sell, trade, or rent your personal information to third parties.
        
        4. DATA SECURITY
        
        We implement appropriate security measures to protect your information against unauthorized access, alteration, disclosure, or destruction.
        
        5. CHILDREN'S PRIVACY
        
        Our game is designed for users of all ages. We do not knowingly collect personal information from children under 13.
        
        6. YOUR RIGHTS
        
        You have the right to:
        • Access your personal information
        • Correct inaccurate information
        • Delete your account and data
        • Opt-out of data collection
        
        7. CHANGES TO THIS POLICY
        
        We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the app.
        
        8. CONTACT US
        
        If you have any questions about this Privacy Policy, please contact us at:
        
        Email: privacy@rootbet.com
        Website: www.rootbet.com/privacy
        
        © 2025 RootBet Games. All rights reserved.
        """
        return lbl
    }()
    
    private let agreeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Agree", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.sigmarOne(18)
        btn.backgroundColor = UIColor(red: 0.65, green: 0.48, blue: 0.79, alpha: 1.00)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 0.95)
        
        view.addSubview(backgroundImageView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentLabel)
        view.addSubview(agreeButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(agreeButton.snp.top).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        agreeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(56)
        }
    }
    
    private func setupActions() {
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func agreeButtonTapped() {
        dismiss(animated: true)
    }
}
