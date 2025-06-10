//
//  MemoryMatchGameViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit
import AVFoundation

class MemoryMatchGameViewController: BaseGameViewController {
    
    // MARK: - Services / VM
    private let viewModel = MemoryMatchViewModel()
    private let userService = UserDataService.shared
    
    // MARK: - Audio players
    private var correctPlayer: AVAudioPlayer?
    private var wrongPlayer: AVAudioPlayer?
    private var showPlayer: AVAudioPlayer?
    
    // MARK: - Game State
    enum GameState { case ready, showingSequence, waitingForInput, gameOver }
    private var gameState: GameState = .ready
    
    private var livesRemaining = 3
    private var level = 1
    
    // MARK: - UI
    private let cardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled  = false
        return cv
    }()
    
    // MARK: - Game Logic
    private var currentSequence: [Int] = []
    private var playerSequence:  [Int] = []
    private var sequenceIndex = 0
    private var distractorPositions: Set<Int> = []
    
    private let gridPositions = 9
    
    // MARK: - Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameType = .memoryMatch
        
        setupMemoryMatchUI()
        setupMemoryMatchConstraints()
        bindViewModel()
        setupAudioPlayers()
        
        timeLabel.isHidden = true
        updateUI()
    }
    
    // MARK: - Audio
    
    private func setupAudioPlayers() {
        setupPlayer(named: "match_correct", into: &correctPlayer)
        setupPlayer(named: "match_wrong", into: &wrongPlayer)
        setupPlayer(named: "match_show", into: &showPlayer)
    }
    
    private func setupPlayer(named file: String, into player: inout AVAudioPlayer?) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "wav") else {
            print("⚠️ No audio file \(file).wav"); return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 0.7
        } catch {
            print("❌ Audio init error \(file): \(error)")
        }
    }
    
    private func playCorrect() { correctPlayer?.currentTime = 0; correctPlayer?.play() }
    private func playWrong() { wrongPlayer?.currentTime = 0; wrongPlayer?.play() }
    private func playShow() { showPlayer?.currentTime = 0; showPlayer?.play() }
    
    private func stopAllSounds() {
        correctPlayer?.stop()
        wrongPlayer?.stop()
        showPlayer?.stop()
    }
    
    // MARK: - VM binding
    
    private func bindViewModel() { viewModel.delegate = self }
    
    // MARK: - UI setup
    
    private func setupMemoryMatchUI() {
        view.addSubview(cardsCollectionView)
        
        cardsCollectionView.delegate   = self
        cardsCollectionView.dataSource = self
        cardsCollectionView.register(MemoryCardCell.self,
                                     forCellWithReuseIdentifier: "MemoryCardCell")
    }
    
    private func setupMemoryMatchConstraints() {
        cardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(playButton.snp.top).offset(-20)
        }
    }
    
    // MARK: - Game control
    
    override func playButtonTapped() {
        super.playButtonTapped()
        HapticManager.shared.mediumTap()
        
        switch gameState {
        case .ready:
            startRound()
        case .gameOver:
            resetGame()
        default: break
        }
    }
    
    private func startRound() {
        gameState = .showingSequence
        playButton.isHidden = true
        cardsCollectionView.isUserInteractionEnabled = false
        playerSequence.removeAll()
        sequenceIndex = 0
        distractorPositions.removeAll()
        
        generateNewSequence()
        if level >= 4 { addDistractorCrystals() }
        
        cardsCollectionView.reloadData()
        hideAllCrystals()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.showSequence() }
    }
    
    private func resetGame() {
        stopAllSounds()
        
        level = 1
        livesRemaining  = 3
        gameState = .ready
        currentSequence.removeAll()
        playerSequence.removeAll()
        distractorPositions.removeAll()
        
        viewModel.resetGame()
        cardsCollectionView.reloadData()
        hideAllCrystals()
        
        playButton.setTitle("Start Game", for: .normal)
        playButton.backgroundColor = UIColor(hex: "#A77BCA")
        playButton.isHidden        = false
        
        updateUI()
    }
    
    private func loseLife() {
        livesRemaining -= 1
        updateUI()
        playWrong()
        HapticManager.shared.error()
        
        if livesRemaining <= 0 {
            handleGameOver()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.startRound() }
        }
    }
    
    private func addDistractorCrystals() {
        distractorPositions.removeAll()

        let maxDistractors = min(1 + level / 2,
                                 gridPositions - currentSequence.count)

        guard maxDistractors > 0 else { return }

        while distractorPositions.count < maxDistractors {
            let pos = Int.random(in: 0..<gridPositions)
            if !currentSequence.contains(pos) {
                distractorPositions.insert(pos)
            }
        }
    }

    private func handleGameOver() {
        gameState = .gameOver
        stopAllSounds()
        
        saveBestScore(viewModel.currentScore)
        let isRecord = isNewRecord(score: viewModel.currentScore)
        let coins = viewModel.currentScore / 10
        if coins > 0 { userService.addCoins(coins) }
        
        playButton.setTitle("Try Again", for: .normal)
        playButton.backgroundColor = UIColor(hex: "#A77BCA")
        playButton.isHidden        = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showGameResult(score: self.viewModel.currentScore,
                                isNewRecord: isRecord,
                                won: false)
        }
    }
    
    private func sequenceCompleted() {
        gameState = .ready
        cardsCollectionView.isUserInteractionEnabled = false
        hideAllCrystals()
    
        let addScore = level * 25 + distractorPositions.count * 5
        viewModel.addScore(addScore)
        
        playCorrect()
        HapticManager.shared.success()
        
        level += 1
        updateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { self.startRound() }
    }
    
    private func gameWon() {
        gameState = .gameOver
        stopAllSounds()
        
        saveBestScore(viewModel.currentScore)
        let isRecord = isNewRecord(score: viewModel.currentScore)
        let coins    = viewModel.currentScore / 5
        userService.addCoins(coins)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showGameResult(score: self.viewModel.currentScore,
                                isNewRecord: isRecord,
                                won: true)
        }
    }
    
    // MARK: - Sequence generation / display
    
    private func generateNewSequence() {
        let length = min(2 + level, 7)
        currentSequence = []
        
        var used: Set<Int> = []
        while currentSequence.count < length {
            let pos = Int.random(in: 0..<gridPositions)
            if used.insert(pos).inserted {
                currentSequence.append(pos)
            }
        }
    }
    
    private func showSequence() {
        let showTime: TimeInterval = max(1.0  - Double(level) * 0.08, 0.4)
        let pauseTime: TimeInterval = max(0.3  - Double(level) * 0.02, 0.1)
        
        for (idx, pos) in currentSequence.enumerated() {
            let showDelay = Double(idx)*(showTime+pauseTime)
            let hideDelay = showDelay + showTime
            
            DispatchQueue.main.asyncAfter(deadline: .now() + showDelay) {
                self.showCrystal(at: pos); self.playShow()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + hideDelay) {
                self.hideCrystal(at: pos)
            }
        }
        
        if !distractorPositions.isEmpty && level >= 4 {
            let start = Double(currentSequence.count)*(showTime+pauseTime) + 0.5
            for (idx, pos) in distractorPositions.enumerated() {
                let show = start + Double(idx)*0.6
                let hide = show  + 0.4
                DispatchQueue.main.asyncAfter(deadline: .now() + show) {
                    self.showCrystal(at: pos)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + hide) {
                    self.hideCrystal(at: pos)
                }
            }
        }
        
        let totalTime = Double(currentSequence.count)*(showTime+pauseTime) + 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime) {
            self.gameState = .waitingForInput
            self.cardsCollectionView.isUserInteractionEnabled = true
            self.hideAllCrystals()
        }
    }
    
    // MARK: - Player input
    
    private func playerTappedCrystal(at position: Int) {
        guard gameState == .waitingForInput else { return }
        
        if distractorPositions.contains(position) {
            loseLife(); return
        }
        if position == currentSequence[sequenceIndex] {
            sequenceIndex += 1
            playCorrect()
            showCrystal(at: position)
            
            if sequenceIndex >= currentSequence.count {
                sequenceCompleted()
            }
        } else {
            loseLife()
        }
    }
    
    // MARK: - UI helpers
    
    private func hideAllCrystals() {
        for i in 0..<gridPositions {
            (cardsCollectionView.cellForItem(at: IndexPath(item: i, section: 0))
             as? MemoryCardCell)?.setCrystal(hidden: true)
        }
    }
    
    private func showCrystal(at pos: Int) {
        (cardsCollectionView.cellForItem(at: IndexPath(item: pos, section: 0))
         as? MemoryCardCell)?.setCrystal(hidden: false)
    }
    
    private func hideCrystal(at pos: Int) {
        (cardsCollectionView.cellForItem(at: IndexPath(item: pos, section: 0))
         as? MemoryCardCell)?.setCrystal(hidden: true)
    }
    
    private func updateUI() {
        coinsLabel.text = "\(userService.coins)"
        scoreLabel.text = "\(viewModel.currentScore)"
        roundLabel.text = "\(livesRemaining)/3"
    }
    
    // MARK: - Best score
    
    private func isNewRecord(score: Int) -> Bool {
        score > UserDefaults.standard.integer(forKey: "MemoryMatchBestScore")
    }
    
    private func saveBestScore(_ score: Int) {
        let best = UserDefaults.standard.integer(forKey: "MemoryMatchBestScore")
        if score > best {
            UserDefaults.standard.set(score, forKey: "MemoryMatchBestScore")
        }
    }
    
    // MARK: - Result screen
    private func showGameResult(score: Int,
                                isNewRecord: Bool,
                                won: Bool) {
        let resultType: ResultType = won ? .win : .lost
        
        let winLoseVC = WinLoseViewController()
        winLoseVC.gameType = .memoryMatch
        winLoseVC.resultType = resultType
        winLoseVC.score = "\(score)"
        winLoseVC.isNewRecord = isNewRecord
        winLoseVC.delegate = self
        
        winLoseVC.modalPresentationStyle = .fullScreen
        present(winLoseVC, animated: true)
    }
    
    
    deinit { stopAllSounds() }
}

// MARK: - CollectionView

extension MemoryMatchGameViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection _: Int) -> Int { gridPositions }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt ip: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "MemoryCardCell", for: ip) as! MemoryCardCell
        let idx  = ip.item % viewModel.availableCrystals.count
        cell.configure(with: viewModel.availableCrystals[idx])
        cell.setCrystal(hidden: true)
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt ip: IndexPath) {
        playerTappedCrystal(at: ip.item)
    }
    
    func collectionView(_ cv: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let w = (cv.frame.width - padding*2) / 3
        return CGSize(width: w, height: w)
    }
}

// MARK: - Delegates

extension MemoryMatchGameViewController: GameViewModelDelegate {
    func gameDidStart() {}
    func gameDidEnd(score _: Int) {}
    func scoreDidUpdate(_ _: Int) { updateUI() }
    func livesDidUpdate(_: Int) {}
    func timeDidUpdate(_: Int) {}
}

extension MemoryMatchGameViewController: WinLoseDegateProtocol {
    func tryAgainTapped() {
        dismiss(animated: false) { self.resetGame() }
    }
    func homeTapped()  {
        dismiss(animated: false) { self.navigationController?.popToRootViewController(animated: false) }
    }
    func claimTapped() { homeTapped() }
}
