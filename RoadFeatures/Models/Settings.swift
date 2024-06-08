//
//  Settings.swift
//  RoadFeatures
//
//  Created by Alex Gav on 27.01.2024.
//

import UIKit

enum Settings: String, CaseIterable {
    
    case account
    case darkTheme
    case yourSuggestions
    case aboutAuthors
    
    var title: String {
        switch self {
        case .account:
            String(localized: "Account")
        case .darkTheme:
            String(localized: "Dark theme")
        case .yourSuggestions:
            String(localized: "Your suggestions")
        case .aboutAuthors:
            String(localized: "About authors")
        }
    }
    
    var icon: UIImage {
        switch self {
        case .aboutAuthors:
            UIImage(named: "account")!
        default:
            UIImage(named: rawValue)!
        }
    }
}
