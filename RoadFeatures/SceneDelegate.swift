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
        
        let MapStoryboard = UIStoryboard(name: "MapViewController", bundle: nil)

        let initialVC = MapStoryboard.instantiateInitialViewController()
        
        //let tabBarController = UITabBarController()
        
        let navigationController = UINavigationController(rootViewController: initialVC!)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()

    }
    
}

