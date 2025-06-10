//
//  MemoryCardCell.swift
//  RootBet
//
//  Created by Пользователь on 01.06.2025.
//

import UIKit
import SnapKit

class MemoryCardCell: UICollectionViewCell {
    
    private let crystalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let backgroundCardView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.25
        view.backgroundColor = UIColor(hex: "#5722A1")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(backgroundCardView)
        contentView.addSubview(crystalImageView)
        
        backgroundCardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        crystalImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
        
        layer.shadowColor = UIColor.purple.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        setCrystal(hidden: true)
    }
    
    func configure(with crystalName: String) {
        crystalImageView.image = UIImage(named: crystalName)
        
        if crystalImageView.image == nil {
            crystalImageView.backgroundColor = UIColor.systemBlue
            print("⚠️ Crystal image not found: \(crystalName)")
        }
    }
    
    func setCrystal(hidden: Bool) {
        crystalImageView.isHidden = hidden
        backgroundCardView.isHidden = !hidden
        
        if hidden {
            backgroundCardView.backgroundColor = UIColor(hex: "#5722A1")
        } else {
            backgroundCardView.backgroundColor = UIColor.clear
        }
    }
    
    
    func highlight() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.backgroundCardView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
                self.backgroundCardView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            }
        }
    }
    
    func showSuccess() {
           UIView.animate(withDuration: 0.3, animations: {
               self.backgroundCardView.layer.borderColor = UIColor.green.cgColor
               self.backgroundCardView.layer.borderWidth = 0.25
           }) { _ in
               UIView.animate(withDuration: 0.3) {
                   self.backgroundCardView.layer.borderColor = UIColor.green.cgColor
                   self.backgroundCardView.layer.borderWidth = 0.25
               }
           }
       }
       
       func showError() {
           UIView.animate(withDuration: 0.2, animations: {
               self.backgroundCardView.layer.borderColor = UIColor.red.cgColor
               self.backgroundCardView.layer.borderWidth = 0.25
               self.transform = CGAffineTransform(translationX: -5, y: 0)
           }) { _ in
               UIView.animate(withDuration: 0.2) {
                   self.transform = CGAffineTransform(translationX: 5, y: 0)
               } completion: { _ in
                   UIView.animate(withDuration: 0.2) {
                       self.transform = .identity
                       self.backgroundCardView.layer.borderColor = UIColor.white.cgColor
                       self.backgroundCardView.layer.borderWidth = 0.25
                   }
               }
           }
       }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setCrystal(hidden: true)
        crystalImageView.image = nil
        transform = .identity
        backgroundCardView.backgroundColor = UIColor.clear
    }
}
