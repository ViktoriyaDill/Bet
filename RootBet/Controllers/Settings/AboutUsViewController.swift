//
//  AboutUsViewController.swift
//  RootBet
//
//  Created by Пользователь on 03.06.2025.
//


import UIKit
import SnapKit

class AboutUsViewController: UIViewController {
    
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
        lbl.text = "ABOUT US"
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
            Lorem ipsum dolor sit amet. Eum pariatur quas id sint omnis ad dolor ipsam et repellat consequuntur ab nesciunt dignissimos quo cumque aliquid qui sunt possimus. Et velit quae quo doloribus enim et voluptates labore non adipisci consequatur ea natus galisum et enim debitis sit explicabo nobis. Sit debitis animi id magni adipisci qui repellendus sapiente quo nemo tenetur ut voluptatem ullam et nemo laborum! Qui nihil amet est labore necessitatibus sit quia necessitatibus vel velit quaerat sit officia quia.

            Qui quaerat distinctio ut ipsa esse sit quia nihil et adipisci odio est nisi fugit et laborum molestiae et cumque optio. Et officia voluptas eum necessitatibus quae aut quos beatae. Id dolorem numquam in quas earum aut voluptates soluta ut atque dolorum?
            
            © 2025 RootBet Games. All rights reserved.
            """
        return lbl
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
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
        view.addSubview(doneButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(doneButton.snp.top).offset(-20)
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
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(56)
        }
    }
    
    private func setupActions() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
}
