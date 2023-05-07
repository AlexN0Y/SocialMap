//
//  RegistrationViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func createUserName() {
        //        guard let name = nameField.text, let email = emailField.text, let password = passwordField.text else {
        //            return
        //        }
        //        UserDefaults.standard.set(name, forKey: "userName")
        //        UserDefaults.standard.set(email, forKey: "userEmail")
        //        UserDefaults.standard.set(password, forKey: "userPassword")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController: UITextFieldDelegate {
}
