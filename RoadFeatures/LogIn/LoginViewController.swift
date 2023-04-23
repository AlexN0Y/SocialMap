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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func logInAction() {
    }
    
    @IBAction func signUpTapped() {
        let registrationStoryboard = UIStoryboard(name: "Registration", bundle: nil)
        let registrationViewController = registrationStoryboard.instantiateViewController(withIdentifier: "registrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
}

