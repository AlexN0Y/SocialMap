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
        
        let favouritesStoryboard = UIStoryboard(name: "FavouritesViewController", bundle: nil)
        let mapStoryboard = UIStoryboard(name: "MapViewController", bundle: nil)
        let settingsStoryboard = UIStoryboard(name: "SettingsViewController", bundle: nil)

        let favouritesViewController = favouritesStoryboard.instantiateViewController(withIdentifier: "favouritesViewController")
        let favouritesNavigationController = UINavigationController(rootViewController: favouritesViewController)
        favouritesViewController.title = "Favourites"
        favouritesViewController.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star.fill"), tag: 0)
        
        let mapViewController = mapStoryboard.instantiateViewController(withIdentifier: "mapViewController")
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        mapViewController.title = "Map"
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        
        let settingsViewController = settingsStoryboard.instantiateViewController(withIdentifier: "settingsViewController")
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.title = "Settings"
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)

        
        let tabBarViewController = UITabBarController()
        tabBarViewController.viewControllers = [favouritesNavigationController, mapNavigationController, settingsNavigationController]
        

            
        window.rootViewController = tabBarViewController
        
        self.window = window
        
        window.makeKeyAndVisible()

    }
    
}

