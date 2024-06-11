//
//  HUDType.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.06.2024.
//

import Foundation

enum HUDType {
    
    // MARK: - Cases
    
    case error(String)
    case success(String)
    case loader
    
    // MARK: - Public Properties
    
    var message: String {
        switch self {
        case let .error(text): text
        case let .success(text): text
        case .loader: String(localized: "Loading...")
        }
    }
    
    var isAutoDismissable: Bool {
        if case .loader = self {
            return false
        }
        return true
    }
    
    var shouldDismissOnTap: Bool {
        if case .loader = self {
            return false
        }
        return true
    }
    
    var isLoader: Bool {
        if case .loader = self {
            return true
        } else {
            return false
        }
    }
    
    var title: String {
        switch self {
        case .error(_):
            "Error"
        case .success(_):
            "Success"
        case .loader:
            "Loader"
        }
    }
}
