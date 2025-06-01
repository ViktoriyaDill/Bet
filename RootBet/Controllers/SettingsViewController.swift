//
//  SettingsViewController.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let settings = [
        ("Sound Effects", "soundEnabled"),
        ("Haptic Feedback", "hapticEnabled")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsUI()
        setupSettingsConstraints()
    }
    
    private func setupSettingsUI() {
        title = "Settings"
        view.backgroundColor = UIColor(red: 0.15, green: 0.1, blue: 0.3, alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        
        view.addSubview(tableView)
    }
    
    private func setupSettingsConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        let setting = settings[indexPath.row]
        cell.textLabel?.text = setting.0
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        
        let switchControl = UISwitch()
        switchControl.isOn = UserDefaults.standard.bool(forKey: setting.1)
        switchControl.tag = indexPath.row
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = switchControl
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let setting = settings[sender.tag]
        UserDefaults.standard.set(sender.isOn, forKey: setting.1)
        HapticManager.shared.impact(.light)
    }
}
