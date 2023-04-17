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
        var rootVC: UIViewController
//
//        // Check if the app has been opened before
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//
//        if launchedBefore {
//            // Check if user is logged in
//            if UserDefaults.standard.bool(forKey: "loggedIn") {
//                // Show screen with greeting and logout button
//                let username = UserDefaults.standard.string(forKey: "username") ?? ""
//                let homeVC = MapViewController(username: username)
//                rootVC = homeVC
//            } else {
//                // Show login screen
//                let loginVC = LoginViewController()
//                rootVC = loginVC
//            }
//        } else {
//            // Show account creation screen
//            let registrationVC = RegistrationViewController()
//            rootVC = registrationVC
//            // Set launchedBefore to true
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//        }
//
//        window.rootViewController = rootVC
//        self.window = window
//        window.makeKeyAndVisible()
    }
    
}

