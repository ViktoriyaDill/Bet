//
//  BaseViewController.swift
//  RootBet
//
//  Created by Пользователь on 03.06.2025.
//

import UIKit

class BaseViewController: UIViewController {

    let themeManager = ThemeManager.shared
    private let userService = UserDataService.shared
    private var backgroundImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemeObservers()
        applyCurrentTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.restoreFieldBorders()
        }
    }


    func applyCurrentTheme() {
        let theme = userService.currentTheme
        let effects = userService.visualEffects
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = nil

        if effects == "Ice Chill" {
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: "IceBG")
            imageView.contentMode = .scaleAspectFill
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(imageView, at: 0)
            backgroundImageView = imageView
            view.backgroundColor = .clear
        }
        else if theme == "Dark Mode" {
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: "BG 1")
            imageView.contentMode = .scaleAspectFill
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(imageView, at: 0)
            backgroundImageView = imageView
            view.backgroundColor = .clear
        }
        else if theme == "Light Mode" {
            let imageView = UIImageView(frame: view.bounds)
            imageView.image = UIImage(named: "BGLightMode")
            imageView.contentMode = .scaleAspectFill
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(imageView, at: 0)
            backgroundImageView = imageView
            view.backgroundColor = .clear
        }
        else if theme == "Classic Mode" {
            view.backgroundColor = UIColor(red: 0.28, green: 0.23, blue: 0.44, alpha: 1.00)
        }

        applyThemeToElements(theme: theme, effects: effects)
    }



    func applyThemeToElements(theme: String, effects: String) {
        applyEffectsToAllFields(effects: effects)
    }

    func applyEffectsToAllFields(effects: String) {
        let views = getAllInteractiveViews(in: view)
        for v in views {
            themeManager.applyVisualEffects(to: v, effect: effects)
        }
    }
    
    func restoreFieldBorders() {
        let views = getAllInteractiveViews(in: view)
        for v in views {
            if let button = v as? UIButton {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.cgColor
            }
        }
    }


    func getAllInteractiveViews(in container: UIView) -> [UIView] {
        var interactive: [UIView] = []

        for sub in container.subviews {
            if sub is UIButton || sub is UITextField || sub is UITextView || sub.layer.cornerRadius > 0 {
                interactive.append(sub)
            }
            interactive.append(contentsOf: getAllInteractiveViews(in: sub))
        }

        return interactive
    }
    
    @objc func updateAvatarDisplay() {
        // default implementation or empty
    }

    // MARK: Notifications

    private func setupThemeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .visualEffectsDidChange, object: nil)
    }

    @objc private func themeDidChange(_ notification: Notification) {
        DispatchQueue.main.async { self.applyCurrentTheme() }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
