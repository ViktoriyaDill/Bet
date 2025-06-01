//
//  GameDetailViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

final class GameDetailViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG 1")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        return imageView
    }()

    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prevBtn"), for: .normal)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .center
        return btn
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Game"
        lbl.font = UIFont.sigmarOne(32)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()

    private let cardContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.cgColor
        v.clipsToBounds = true
        return v
    }()

    private let gameImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let gameTitleLable: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.sigmarOne(16)
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        return lbl
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12.0)
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()

    private let playButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Play", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 0.65, green: 0.48, blue: 0.79, alpha: 1.00)
        btn.layer.cornerRadius = 18
        return btn
    }()

    private let prevButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "prevBtn"), for: .normal)
        return btn
    }()

    private let nextButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nextBtn"), for: .normal)
        return btn
    }()


    private let viewModel: GameDetailViewModel
    private var playGradientLayer: CAGradientLayer?

    init(startIndex: Int = 0) {
        self.viewModel = GameDetailViewModel(startIndex: startIndex)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: – life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)

        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.onIndexChanged?(viewModel.currentIndex)
    }

    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(cardContainerView)
        cardContainerView.addSubview(gameImageView)
        cardContainerView.addSubview(gameTitleLable)
        cardContainerView.addSubview(descriptionLabel)
        view.addSubview(playButton)
        view.addSubview(prevButton)
        view.addSubview(nextButton)

        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }

    private func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(48)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        cardContainerView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(cardContainerView.snp.width).multipliedBy(1.2)
        }

        gameImageView.snp.makeConstraints { make in
            make.top.leading.trailing.height.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.7)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
        
        gameTitleLable.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(descriptionLabel.snp.top).inset(4)
        }

        playButton.snp.makeConstraints { make in
            make.top.equalTo(cardContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(64)
        }

        prevButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.equalToSuperview().inset(80)
            make.width.height.equalTo(48)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.trailing.equalToSuperview().inset(80)
            make.width.height.equalTo(48)
        }
    }


    private func bindViewModel() {
           viewModel.onIndexChanged = { [weak self] index in
               guard let self = self else { return }
               let model = self.viewModel.currentGame()
               
               UIView.transition(with: self.cardContainerView, duration: 0.3, options: .transitionCrossDissolve) {
                   self.gameTitleLable.text = model.title
                   self.gameImageView.image = model.image
                   self.descriptionLabel.text = model.description
               }
               
               self.prevButton.isEnabled = self.viewModel.canGoPrevious
               self.nextButton.isEnabled = self.viewModel.canGoNext
               self.prevButton.alpha = self.viewModel.canGoPrevious ? 1.0 : 0.4
               self.nextButton.alpha = self.viewModel.canGoNext ? 1.0 : 0.4
           }
       }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapPlay() {
        // Тут запускаємо гру. Наприклад:
        let current = viewModel.currentIndex
        switch current {
        case 0:
            let vc = ColorSpinGameViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case 1:
            let vc = StackTowerGameViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case 2:
            let vc = BubbleCatchGameViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case 3:
            let vc = MemoryMatchGameViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        default:
            break
        }
    }

    @objc private func didTapPrev() {
        viewModel.goToPrevious()
    }

    @objc private func didTapNext() {
        viewModel.goToNext()
    }
}

