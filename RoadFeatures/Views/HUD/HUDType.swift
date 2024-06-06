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
    
    // MARK: - Public Properties
    
    var message: String {
        switch self {
        case .error(let text): text
        }
    }
    
    var title: String {
        switch self {
        case .error(_):
            "Error"
        }
    }
}

