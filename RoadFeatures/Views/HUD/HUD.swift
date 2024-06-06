//
//  HUD.swift
//  RoadFeatures
//
//  Created by Alex Gav on 07.06.2024.
//

import UIKit

enum HUD {
    
    // MARK: - Private Static Properties
    
    private static let viewTag = Int.random(in: 1234...56789)
    
    private static var window: UIWindow? {
        UIApplication.shared.presentWindow
    }
    
    // MARK: - Public Static Methods
    
    static func present(
        type: HUDType
    ) {
        dismiss(withDuration: 0.35) {
            let view = HUDView(type: type)
            view.tag = viewTag
            
            guard let window else {
                fatalError("Could not find UIWindow to present HUD.")
            }
            
            DispatchQueue.main.async {
                view.present(
                    from: window
                )
            }
        }
    }
    
    static func dismiss(
        withDuration duration: TimeInterval,
        completion: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            guard
                let view = window?.subviews.first(where: { $0.tag == viewTag }),
                let hudView = view as? HUDView
            else {
                completion?()
                return
            }
            
            hudView.dismiss(withDuration: duration, completion: completion)
        }
    }
}
