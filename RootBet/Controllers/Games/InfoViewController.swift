//
//  InfoViewController.swift
//  RootBet
//
//  Created by Пользователь on 06.06.2025.
//

import UIKit
import SnapKit

final class InfoViewController: UIViewController {
    
    var gameType: GameType?
    
    private let scroll = UIScrollView()
    private let scrollContainer = UIView()
    
    private let headerTitle: UILabel = {
        let t = UILabel()
        t.text = "Game Rules"
        t.font = UIFont.sigmarOne(32)
        t.textColor = UIColor(red: 0.15, green: 0.03, blue: 0.43, alpha: 1.00)
        t.textAlignment = .center
        return t
    }()
    
    
    private let closeButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = .white
        return b
    }()
    
    private let rulesGame: UILabel = {
        let rg = UILabel()
        rg.font = UIFont.systemFont(ofSize: 16)
        rg.numberOfLines = 0
        rg.textColor = .white
        rg.textAlignment = .left
        return rg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstrains()
        getRuleText()
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#4E4A8D")
        
        scrollContainer.backgroundColor = .white.withAlphaComponent(0.2)
        scrollContainer.layer.cornerRadius = 12
        scrollContainer.layer.borderColor = UIColor.white.cgColor
        scrollContainer.layer.borderWidth = 1
        
        view.addSubview(closeButton)
        view.addSubview(headerTitle)
        view.addSubview(scroll)
        view.addSubview(scrollContainer)
        scrollContainer.addSubview(rulesGame)
    }
    
    private func makeConstrains() {
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.height.width.equalTo(40)
        }
        
        headerTitle.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        scroll.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(14)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.leading.equalTo(scroll.snp.leading).inset(16)
            make.trailing.equalTo(scroll.snp.trailing).inset(16)
            make.top.equalTo(scroll.snp.top)
            make.bottom.equalTo(scroll.snp.bottom).inset(16)
        }
        
        rulesGame.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(4)
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    private func getRuleText() {
        guard let type = self.gameType else { return }
        
        switch type {
        case .colorSpin:
            rulesGame.text = """
            HOW TO PLAY:
            Start the Spin – Tap the screen to start the wheel spinning. The colors will rotate at increasing speeds.
            Time Your Tap – When the desired color reaches the indicator line, tap the screen to stop the wheel.
            Win Points:
            If you land on the target color, you earn maximum points!
            If you land close to the target color, you get a partial reward.
            If you miss completely, you lose the round.
            Bonus Streaks – Hitting the correct color multiple times in a row doubles or even triples your rewards!
            Challenges & Rewards – Some rounds may have special challenges (e.g., faster spin, hidden colors). Completing them earns extra bonuses.
"""
        case .stackTower:
            rulesGame.text = """
            HOW TO PLAY:
            Your goal is simple: stack blocks on top of each other to build the tallest tower possible! The more precise your placement, the higher your score.
            Blocks move side to side automatically.
            Tap the screen at the right moment to drop the block.
            If the block is perfectly aligned, you get bonus points!
            If the block is slightly off, the overhanging part falls off, making the next block smaller.
            Keep stacking and aim for the highest tower possible!
"""
        case .bubbleCatch:
            rulesGame.text = """
            HOW TO PLAY:
            Your goal is simple: catch the falling bubbles in the correct zones while avoiding the wrong ones! The more accurate your catches, the higher your score.
            Bubbles will fall from the top of the screen at different speeds.
            Catch bubbles in the correct zone to earn points.
            Avoid bubbles landing in the wrong zone, or you'll lose a life!
            The game gets faster as you progress - stay sharp!
            Score multipliers apply for consecutive successful catches!
"""
        case .memoryMatch:
            rulesGame.text = """
            HOW TO PLAY:
            Memorize the sequence of symbols and repeat them correctly!
            Game Start:
            A sequence of symbols appears on the screen.
            Your task is to remember the exact order in which they appear.
            Repeat Phase:
            After a short time, the symbols disappear.
            Tap the symbols in the correct sequence to match what you saw.
            Increasing Difficulty:
            As the game progresses, the sequence becomes longer.
            The memorization time gets shorter.
            At higher levels, distracting symbols may appear to test your focus.
            Scoring & Rewards:
            Each correct sequence earns points.
            Mistakes may result in a penalty or end the game.
            Combo bonuses are awarded for multiple perfect rounds in a row.
"""
        }
    }
    
    
}
