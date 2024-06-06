//
//  UIApplication+Ext.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.06.2024.
//

import UIKit

// MARK: - Public Properties

extension UIApplication {
    
    var presentWindow: UIWindow? {
        connectedScenes
            .compactMap {
                ($0 as? UIWindowScene)?.keyWindow
            }
            .last
    }
}

