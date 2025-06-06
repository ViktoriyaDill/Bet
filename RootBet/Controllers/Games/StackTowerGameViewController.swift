//
//  StackTowerGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import Foundation
import UIKit
import SnapKit

class StackTowerGameViewController: BaseGameViewController {
    
    private let viewModel = StackTowerViewModel()
    
    private let gameAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let dropButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DROP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 12
        return button
    }()
    
    private var blockViews: [UIView] = []
    private var currentBlockView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackTowerUI()
        setupStackTowerConstraints()
        setupStackTowerActions()
        bindViewModel()
    }
    
    private func setupStackTowerUI() {
        view.addSubview(gameAreaView)
        view.addSubview(dropButton)
    }
    
    private func setupStackTowerConstraints() {
        gameAreaView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(dropButton.snp.top).offset(-20)
        }
        
        dropButton.snp.makeConstraints { make in
            make.bottom.equalTo(playButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
    private func setupStackTowerActions() {
        dropButton.addTarget(self, action: #selector(dropButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    @objc private func dropButtonTapped() {
        viewModel.dropBlock()
    }
    
    override func playButtonTapped() {
        super.playButtonTapped()
        viewModel.startGame()
        playButton.setTitle("Game Active", for: .normal)
        playButton.backgroundColor = .systemGray
        playButton.isEnabled = false
        dropButton.isEnabled = true
    }
}

extension StackTowerGameViewController: GameViewModelDelegate {
    func infoButtoTapped() {}
    
    func gameDidStart() {
        blockViews.forEach { $0.removeFromSuperview() }
        blockViews.removeAll()
        currentBlockView?.removeFromSuperview()
        currentBlockView = nil
    }
    
    func gameDidEnd(score: Int) {
        playButton.setTitle("Start Game", for: .normal)
        playButton.backgroundColor = .systemGreen
        playButton.isEnabled = true
        dropButton.isEnabled = false
        
        let alert = UIAlertController(title: "Game Over", message: "Blocks Stacked: \(viewModel.blocks.count)\nFinal Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func scoreDidUpdate(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}
