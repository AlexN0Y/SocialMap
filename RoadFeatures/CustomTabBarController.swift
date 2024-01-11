//
//  CustomTabBarController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 27.04.2023.
//

import UIKit

enum Storyboards {
    
    static let favourites = "FavouritesViewController"
    static let map = "MapViewController"
    static let settings = "SettingsViewController"
}

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private enum Constant {
        enum Images {
            static let map = "map"
            static let favourites = "star.fill"
            static let settings = "gear"
        }
        enum Titles {
            static let map = "Map"
            static let favourites = "Favourites"
            static let settings = "Settings"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        let favouritesViewController: FavouritesViewController = {
            let storyboard = UIStoryboard(name: Storyboards.favourites, bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: FavouritesViewController.self)) as? FavouritesViewController {
                viewController.tabBarItem = UITabBarItem(title: Constant.Titles.favourites, image: UIImage(systemName: Constant.Images.favourites), tag: 0)
                return viewController
            } else {
                fatalError("Unable to create FavouritesViewController")
            }
        } ()
        let favouritesNavigationController = UINavigationController(rootViewController: favouritesViewController)
        
        let mapViewController: MapViewController = {
            let storyboard = UIStoryboard(name: Storyboards.map, bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: MapViewController.self )) as? MapViewController {
                viewController.tabBarItem = UITabBarItem(title: Constant.Titles.map, image: UIImage(systemName: Constant.Images.map), tag: 1)
                return viewController
            } else {
                fatalError("Unable to create MapViewController")
            }
        } ()
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        
        let settingsViewController: SettingsViewController = {
            let storyboard = UIStoryboard(name: Storyboards.settings, bundle: nil)
            if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self)) as? SettingsViewController {
                viewController.tabBarItem = UITabBarItem(title: Constant.Titles.settings, image: UIImage(systemName: Constant.Images.settings), tag: 2)
                return viewController
            } else {
                fatalError("Unable to create SettingsViewController")
            }
        } ()
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        
        self.viewControllers = [favouritesNavigationController, mapNavigationController, settingsNavigationController]
    }
}
