//
//  CustomTabBarController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 27.04.2023.
//

import UIKit

enum Storyboards: String {
    case favourites = "FavouritesViewController"
    case map = "MapViewController"
    case settings = "SettingsViewController"
}

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private enum Constant {
        static let mapImage = "map"
        static let favouritesImage = "star.fill"
        static let settingsImage = "gear"
        static let mapTitle = "Map"
        static let favouritesTitle = "Favourites"
        static let settingsTitle = "Settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let favouritesStoryboard = UIStoryboard(name: Storyboards.favourites.rawValue, bundle: nil)
        let mapStoryboard = UIStoryboard(name: Storyboards.map.rawValue, bundle: nil)
        let settingsStoryboard = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil)
        
        let favouritesViewController = favouritesStoryboard.instantiateViewController(withIdentifier: String(describing: FavouritesViewController.self))
        let favouritesNavigationController = UINavigationController(rootViewController: favouritesViewController)
        favouritesViewController.tabBarItem = UITabBarItem(title: Constant.favouritesTitle, image: UIImage(systemName: Constant.favouritesImage), tag: 0)
        
        
        let mapViewController = mapStoryboard.instantiateViewController(withIdentifier: String(describing: MapViewController.self ))
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        mapViewController.tabBarItem = UITabBarItem(title: Constant.mapTitle, image: UIImage(systemName: Constant.mapImage), tag: 1)
        
        let settingsViewController = settingsStoryboard.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self))
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: Constant.settingsTitle, image: UIImage(systemName: Constant.settingsImage), tag: 2)
        
        self.viewControllers = [favouritesNavigationController, mapNavigationController, settingsNavigationController]
    }
}
