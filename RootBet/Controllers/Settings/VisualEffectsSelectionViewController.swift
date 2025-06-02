//
//  VisualEffectsSelectionViewController.swift
//  RootBet
//
//  Created by Пользователь on 02.06.2025.
//

import UIKit
import SnapKit



protocol VisualEffectsSelectionDelegate: AnyObject {
    func didSelectVisualEffect(_ effect: String)
}

class VisualEffectsSelectionViewController: UIViewController {
    
    weak var delegate: VisualEffectsSelectionDelegate?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BG 1")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "VISUAL EFFECTS"
        lbl.font = UIFont.sigmarOne(24)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    
    private let effects = ["Neon Glow", "Ice Crystals", "Aurora Effect", "No Effects"]
    private var selectedEffect: String = ""
    private let userService = UserDataService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        loadCurrentEffect()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EffectCell.self, forCellReuseIdentifier: "EffectCell")
    }
    
    private func loadCurrentEffect() {
        selectedEffect = userService.visualEffects
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        delegate?.didSelectVisualEffect(selectedEffect)
        dismiss(animated: true)
    }
}

extension VisualEffectsSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return effects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EffectCell", for: indexPath) as! EffectCell
        let effect = effects[indexPath.row]
        let isSelected = effect == selectedEffect
        cell.configure(with: effect, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectItemAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedEffect = effects[indexPath.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
