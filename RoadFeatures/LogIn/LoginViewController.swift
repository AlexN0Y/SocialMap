//
//  ViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private enum Constant {
        static let registrationStoryboardName = "Registration"
        static let registrationViewControllerName = "RegistrationViewController"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInAction() {
    }
    
    @IBAction func signUpTapped() {
        let registrationStoryboard = UIStoryboard(name: Constant.registrationStoryboardName, bundle: nil)
        let registrationViewController = registrationStoryboard.instantiateViewController(withIdentifier: Constant.registrationViewControllerName) as! RegistrationViewController
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
}

