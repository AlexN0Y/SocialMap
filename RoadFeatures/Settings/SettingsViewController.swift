//
//  SettingsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signInOutButton: UIButton!
    private enum Constant {
        static let title = "Settings"
        static let logInStoryboardName = "LogIn"
        static let logInViewControllerName = "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            signInOutButton.setTitle("LogOut", for: .normal)
        } else {
            signInOutButton.setTitle("LogIn", for: .normal)
        }
    }
    
    @IBAction func logInTapped() {
        switch(signInOutButton.titleLabel?.text) {
        case "LogIn":
            let logInStoryboard = UIStoryboard(name: Constant.logInStoryboardName, bundle: nil)
            let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: Constant.logInViewControllerName) as! LoginViewController
            logInViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logInViewController, animated: true)
        case "LogOut":
            do {
                try Auth.auth().signOut()
                signInOutButton.setTitle("LogIn", for: .normal)
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        default:
            fatalError("Button doesn't have title")
        }
    }
    
    
}
