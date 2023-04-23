//
//  SettingsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInTapped() {
        let logInStoryboard = UIStoryboard(name: "LogIn", bundle: nil)
        let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: "logInViewController") as! LoginViewController
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
    

}
