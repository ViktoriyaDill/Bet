//
//  WinLoseViewController.swift
//  RootBet
//
//  Created by Пользователь on 05.06.2025.
//

import UIKit
import SnapKit

protocol WinLoseDegateProtocol: AnyObject {
    func tryAgainTapped()
    func homeTapped()
    func claimTapped()
}

class WinLoseViewController: UIViewController {
    
    weak var delegate: WinLoseDegateProtocol?
    
    var gameType: GameType?
    var resultType: ResultType?
    var score: String?
    var isNewRecord: Bool = true
    
    private let background = UIImageView()
    
    let mainTextStack: UIStackView = {
        let ts = UIStackView()
        ts.axis = .vertical
        ts.spacing = 12
        ts.alignment = .center
        ts.distribution = .fill
        return ts
    }()
    
    let mainTitle: UILabel = {
        let t = UILabel()
        t.font = UIFont.sigmarOne(40)
        t.textColor = .white
        t.numberOfLines = 1
        t.textAlignment = .center
        return t
    }()
    
    let subTitle: UILabel = {
        let t = UILabel()
        t.font = UIFont.sigmarOne(24)
        t.textColor = .white
        t.numberOfLines = 1
        t.textAlignment = .center
        return t
    }()
    
    let resultTitle: UILabel = {
        let t = UILabel()
        t.font = UIFont.sigmarOne(40)
        t.textColor = .white
        t.numberOfLines = 1
        t.textAlignment = .center
        return t
    }()
    
    let tryAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(hex: "#A77BCA")
        button.layer.cornerRadius = 25
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(hex: "#A77BCA")
        button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let result = self.score else { return }
        
        setupUI()
        setupConstrain()
        confirateUI(by: result)
        actionButto()
    }
    
    private func setupUI() {
        view.addSubview(background)
        
        view.addSubview(mainTextStack)
        mainTextStack.addArrangedSubview(mainTitle)
        mainTextStack.addArrangedSubview(subTitle)
        mainTextStack.addArrangedSubview(resultTitle)
        
        view.addSubview(tryAgainButton)
        view.addSubview(homeButton)
    }
    
    private func setupConstrain() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainTextStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(88)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        
        homeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        tryAgainButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(homeButton.snp.top).offset(-22)
            make.height.equalTo(64)
        }
    }
    
    private func confirateUI(by score: String) {
        guard let type = self.gameType else { return }
        guard let result = self.resultType else { return }
        
        switch type {
        case .colorSpin:
            colorSpinResult(of: result, score: score)
        case .stackTower:
            stackTowerResult(by: score, imageName: "GOStackTower")
        case .bubbleCatch:
            stackTowerResult(by: score, imageName: "GOBubbleCatch")
        case .memoryMatch:
            colorSpinResult(of: result, score: score)
        }
    }
    
    private func colorSpinResult(of result: ResultType, score: String) {
        if result == .win {
            background.image = UIImage(named: "Win")
            mainTitle.text = "You win!"
            resultTitle.text = score
            tryAgainButton.isHidden = true
            homeButton.isHidden = false
            homeButton.setTitle("Claim", for: .normal)
        } else {
            background.image = UIImage(named: "Lose")
            mainTitle.text = "You Lost!"
            tryAgainButton.isHidden = false
            homeButton.isHidden = false
        }
    }
    
    private func stackTowerResult(by score: String, imageName: String ) {
        background.image = UIImage(named: "imageName")
        mainTitle.text = "Game Over!"
        subTitle.isHidden = !isNewRecord
        resultTitle.text = score
        tryAgainButton.isHidden = false
        homeButton.isHidden = false
    }
    
    private func actionButto() {
        tryAgainButton.addTarget(self, action: #selector(tryAgainTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
    }
    
    @objc private func tryAgainTapped() {
        delegate?.tryAgainTapped()
    }
    
    @objc private func homeTapped() {
        guard let type = self.gameType else { return }
        guard let result = self.resultType else { return }
        
        if (type == .colorSpin || type == .memoryMatch) && result == .win {
            delegate?.claimTapped()
        } else {
            delegate?.homeTapped()
        }
    }

}
