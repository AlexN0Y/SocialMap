//
//  SceneDelegate.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKey.isDarkModeEnabled.rawValue)
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
        
        let tabBarViewController = CustomTabBarController()
        
        tabBarViewController.selectedIndex = 1
        
        window.rootViewController = tabBarViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
