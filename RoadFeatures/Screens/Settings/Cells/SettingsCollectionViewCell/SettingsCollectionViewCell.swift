//
//  SettingsCollectionViewCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 20.01.2024.
//

import UIKit

protocol SettingsCellDelegate: AnyObject {
    
    func didToggleThemeSwitch()
}

class SettingsCollectionViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var themeModeSwitch: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var chevronImage: UIImageView!
    
    weak var delegate: SettingsCellDelegate?
    
    func configure(for type: Settings) {
        titleLabel.text = type.title
        icon.image = type.icon
        chevronImage.isHidden = false
        themeModeSwitch.isHidden = true
        
        if type == .darkTheme {
            chevronImage.isHidden = true
            themeModeSwitch.isHidden = false
            themeModeSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKey.isDarkModeEnabled.rawValue)
        }
    }
    
    @IBAction private func switchToggled() {
        delegate?.didToggleThemeSwitch()
    }
}
