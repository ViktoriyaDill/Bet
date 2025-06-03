//
//  AvatarSelectionViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

protocol AvatarSelectionDelegate: AnyObject {
    func didSelectAvatar(_ avatarName: String)
}

class AvatarSelectionViewController: BaseViewController {
    
    weak var delegate: AvatarSelectionDelegate?
    private let userService = UserDataService.shared
    
    private var selectedAvatarIndex: Int = 0
    private var selectedBgColorIndex: Int = 0
    
    private let bgColorStack = UIStackView()
    
    private let avatars = [
        "photoUser",
        "Cat", "Fox", "Frog", "Girl",
        "Man2", "Panda", "Robot", "Woman",
        "Woman2", "Woman3", "Yellow"
    ]
    
    private let bgColors: [UIColor] = [
        UIColor(hex: "#8346BC"), // violet
        UIColor(hex: "#DDB43F"), // yellow
        UIColor(hex: "#FF00ED"), // pink
        UIColor(hex: "#34C759"), // green
        UIColor(hex: "#FF3B30")  // red
       ]
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "prevBtn"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SETTINGS"
        label.font = UIFont.sigmarOne(28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let bgColorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Background"
        label.font = UIFont.sigmarOne(12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let bgColorsView: UIView = {
        let st = UIView()
        st.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        st.layer.cornerRadius = 8
        st.layer.borderColor = UIColor.white.cgColor
        st.layer.borderWidth = 1
        return st
    }()
    
    
    private let avatarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Avatar"
        label.font = UIFont.sigmarOne(20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let avatarsView: UIView = {
        let st = UIView()
        st.backgroundColor = UIColor(red: 0.31, green: 0.29, blue: 0.55, alpha: 1.00)
        st.layer.cornerRadius = 8
        st.layer.borderColor = UIColor.white.cgColor
        st.layer.borderWidth = 1
        return st
    }()
    
    private let selectedAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let avatarNameLabel: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 0.37, green: 0.25, blue: 0.53, alpha: 1.00)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .white
        textField.layer.cornerRadius = 1
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 0.65, green: 0.48, blue: 0.79, alpha: 1.00)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        loadCurrentAvatar()
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(avatarTitleLabel)
        view.addSubview(avatarsView)
        avatarsView.addSubview(selectedAvatarImageView)
        avatarsView.addSubview(avatarNameLabel)
        avatarsView.addSubview(collectionView)
        view.addSubview(bgColorsView)
        bgColorsView.addSubview(bgColorsLabel)
        bgColorsView.addSubview(bgColorStack)
        view.addSubview(saveButton)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        bgColorStack.axis = .horizontal
        bgColorStack.distribution = .fillEqually
        bgColorStack.spacing = 12
        
        for (i, color) in bgColors.enumerated() {
            let view = UIView()
            view.backgroundColor = color
            view.layer.cornerRadius = 26
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = (i == selectedBgColorIndex) ? 3 : 0
            view.tag = i
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(colorTapped(_:)))
            view.addGestureRecognizer(tap)
            bgColorStack.addArrangedSubview(view)
        }
    }
    
    private func setupConstraints() {
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top)
            make.centerX.equalToSuperview()
        }
        
        avatarTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        avatarsView.snp.makeConstraints { make in
            make.top.equalTo(avatarTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        
        selectedAvatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(88)
        }
        
        avatarNameLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedAvatarImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(33)
            make.height.equalTo(26)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(avatarNameLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.56)
        }
        
        bgColorsView.snp.makeConstraints { make in
            make.top.equalTo(avatarsView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.12)
        }
        
        bgColorsLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        bgColorStack.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(52)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
    }
    
    private func loadCurrentAvatar() {
        let current = userService.avatarImageName
        if let idx = avatars.firstIndex(of: current) {
            selectedAvatarIndex = idx
        }
        selectedAvatarImageView.image = UIImage(named: avatars[selectedAvatarIndex])
        avatarNameLabel.text = avatars[selectedAvatarIndex]
        selectedAvatarImageView.backgroundColor = userService.avatarBackgroundColor
    }
    
    @objc private func colorTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        selectedBgColorIndex = view.tag
        selectedAvatarImageView.backgroundColor = bgColors[selectedBgColorIndex]
        for (i, v) in bgColorStack.arrangedSubviews.enumerated() {
            v.layer.borderWidth = (i == selectedBgColorIndex) ? 3 : 0
        }
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func saveTapped() {
        let selectedAvatar = avatars[selectedAvatarIndex]
                userService.avatarImageName = selectedAvatar
                userService.avatarBackgroundColor = bgColors[selectedBgColorIndex]
                delegate?.didSelectAvatar(selectedAvatar)
                NotificationCenter.default.post(name: .avatarDidChange, object: selectedAvatar)
                backTapped()
    }
}

extension AvatarSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        let name = avatars[indexPath.item]
        let isSelected = indexPath.item == selectedAvatarIndex
        cell.configure(with: name, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarIndex = indexPath.item
        selectedAvatarImageView.image = UIImage(named: avatars[selectedAvatarIndex])
        avatarNameLabel.text = avatars[selectedAvatarIndex]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20
        let itemsPerRow: CGFloat = 4
        let totalSpacing = spacing * (itemsPerRow + 1)
        let width = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: width, height: width)
    }
}
