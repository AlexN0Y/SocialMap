//
//  SettingsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private enum Constant {
        static let title = "Settings"
        static let logInStoryboardName = "LogIn"
        static let logInViewControllerName = "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
    @IBAction func logInTapped() {
        let logInStoryboard = UIStoryboard(name: Constant.logInStoryboardName, bundle: nil)
        let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: Constant.logInViewControllerName) as! LoginViewController
        logInViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    
}
