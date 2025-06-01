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
            imageView.backgroundColor = UIColor(red: 0.15, green: 0.1, blue: 0.3, alpha: 1.0)
            return imageView
        }()
        
        let scoreLabel: UILabel = {
            let label = UILabel()
            label.text = "Score: 0"
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = "Time: 60"
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        
        let startButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Start Game", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.backgroundColor = UIColor.systemGreen
            button.layer.cornerRadius = 12
            return button
        }()
        
        let backButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("← Back", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupBaseUI()
            setupBaseConstraints()
            setupBaseActions()
        }
        
        func setupBaseUI() {
            view.addSubview(backgroundImageView)
            view.addSubview(scoreLabel)
            view.addSubview(timeLabel)
            view.addSubview(startButton)
            view.addSubview(backButton)
        }
        
        func setupBaseConstraints() {
            backgroundImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            backButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
                make.leading.equalToSuperview().offset(20)
            }
            
            scoreLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
                make.centerX.equalToSuperview()
            }
            
            timeLabel.snp.makeConstraints { make in
                make.top.equalTo(scoreLabel.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            
            startButton.snp.makeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
                make.centerX.equalToSuperview()
                make.width.equalTo(200)
                make.height.equalTo(50)
            }
        }
        
        func setupBaseActions() {
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        }
        
        @objc func backButtonTapped() {
            HapticManager.shared.impact(.light)
            dismiss(animated: true)
        }
        
        @objc func startButtonTapped() {
            // Override in subclasses
        }
    }
