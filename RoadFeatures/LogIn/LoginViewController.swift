//
//  ViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.03.2023.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    private enum Constant {
        static let registrationStoryboardName = "Registration"
        static let registrationViewControllerName = "RegistrationViewController"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func logInAction() {
    }
    
    @IBAction func signUpTapped() {
        let registrationStoryboard = UIStoryboard(name: Constant.registrationStoryboardName, bundle: nil)
        let registrationViewController = registrationStoryboard.instantiateViewController(withIdentifier: Constant.registrationViewControllerName) as! RegistrationViewController
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

