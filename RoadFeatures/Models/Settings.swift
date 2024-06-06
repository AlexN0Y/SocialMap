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
            "Account"
        case .darkTheme:
            "Dark theme"
        case .yourSuggestions:
            "Your suggestions"
        case .aboutAuthors:
            "About authors"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .aboutAuthors:
            return UIImage(named: "account")!
        default:
            return UIImage(named: rawValue)!
        }
    }
}