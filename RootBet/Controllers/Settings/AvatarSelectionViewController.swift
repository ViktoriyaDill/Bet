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

class AvatarSelectionViewController: UIViewController {
    
    weak var delegate: AvatarSelectionDelegate?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG 1")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AVATAR"
        lbl.font = UIFont.sigmarOne(24)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.sigmarOne(18)
        btn.backgroundColor = UIColor(red: 0.65, green: 0.48, blue: 0.79, alpha: 1.00)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private let cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    // Available avatars - you can add more based on your assets
    private let avatars = [
        "photoUser",
        "beautiful-woman-in-purple-dress 1",
        // Add more avatar names from your assets
        "avatar1", "avatar2", "avatar3", "avatar4",
        "avatar5", "avatar6", "avatar7", "avatar8",
        "avatar9", "avatar10", "avatar11", "avatar12"
    ]
    
    private var selectedAvatarIndex: Int = 0
    private let userService = UserDataService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupCollectionView()
        loadCurrentAvatar()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        
        view.addSubview(backgroundImageView)
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cancelButton)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(56)
        }
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: "AvatarCell")
    }
    
    private func loadCurrentAvatar() {
        let currentAvatar = userService.avatarImageName
        if let index = avatars.firstIndex(of: currentAvatar) {
            selectedAvatarIndex = index
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let selectedAvatar = avatars[selectedAvatarIndex]
        delegate?.didSelectAvatar(selectedAvatar)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension AvatarSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        let avatarName = avatars[indexPath.item]
        let isSelected = indexPath.item == selectedAvatarIndex
        cell.configure(with: avatarName, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarIndex = indexPath.item
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 3 // 3 columns with spacing
        return CGSize(width: width, height: width)
    }
}
