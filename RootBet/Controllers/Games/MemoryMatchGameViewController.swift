//
//  MemoryMatchGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

class MemoryMatchGameViewController: BaseGameViewController {
    
    private let viewModel = MemoryMatchViewModel()
    
    private let cardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMemoryMatchUI()
        setupMemoryMatchConstraints()
        bindViewModel()
    }
    
    private func setupMemoryMatchUI() {
        view.addSubview(cardsCollectionView)
        
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.register(MemoryCardCell.self, forCellWithReuseIdentifier: "MemoryCardCell")
    }
    
    private func setupMemoryMatchConstraints() {
        cardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(startButton.snp.top).offset(-20)
        }
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func startButtonTapped() {
        super.startButtonTapped()
        viewModel.startGame()
        startButton.setTitle("Game Active", for: .normal)
        startButton.backgroundColor = .systemGray
        startButton.isEnabled = false
        cardsCollectionView.reloadData()
    }
}

extension MemoryMatchGameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoryCardCell", for: indexPath) as! MemoryCardCell
        let card = viewModel.cards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.flipCard(at: indexPath.item)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 4
        return CGSize(width: width, height: width)
    }
}

extension MemoryMatchGameViewController: GameViewModelDelegate {
    func gameDidStart() {
        cardsCollectionView.reloadData()
    }
    
    func gameDidEnd(score: Int) {
        startButton.setTitle("Start Game", for: .normal)
        startButton.backgroundColor = .systemGreen
        startButton.isEnabled = true
        
        let alert = UIAlertController(title: "Congratulations!", message: "All pairs matched!\nFinal Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func scoreDidUpdate(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}

