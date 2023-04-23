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
        
        let mapStoryboard = UIStoryboard(name: "MapViewController", bundle: nil)
        let settingsStoryboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
        let favouritesStoryboard = UIStoryboard(name: "FavouritesViewController", bundle: nil)

        let mapViewController = mapStoryboard.instantiateViewController(withIdentifier: "mapViewController")
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history , tag: 0)
        let settingsViewController = settingsStoryboard.instantiateViewController(withIdentifier: "settingsViewController")
        settingsViewController.title = "Settings"
        settingsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more , tag: 1)
        let favouritesViewController = favouritesStoryboard.instantiateViewController(withIdentifier: "favouritesViewController")
        favouritesViewController.title = "Favourites"
        favouritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [favouritesViewController, mapViewController, settingsViewController]
            
        window.rootViewController = tabBarViewController
        
        self.window = window
        
        window.makeKeyAndVisible()

    }
    
}

