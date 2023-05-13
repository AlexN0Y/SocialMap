//
//  ViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var userLogin: String?
    private var userPassword: String?
    @IBOutlet private weak var passwordPlaceholder: UIView! {
        didSet {
            let passwordView: LabeledTextfield = .fromNib()
            passwordPlaceholder.addSubview(passwordView)
            passwordView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                passwordView.leadingAnchor.constraint(equalTo: passwordPlaceholder.leadingAnchor),
                passwordView.trailingAnchor.constraint(equalTo: passwordPlaceholder.trailingAnchor),
                passwordView.topAnchor.constraint(equalTo: passwordPlaceholder.topAnchor),
                passwordView.bottomAnchor.constraint(equalTo: passwordPlaceholder.bottomAnchor)
            ])
            passwordView.configureLabeledTextfield(labelText: "Password")
            passwordView.onSave = { [weak self] text in
                self?.userPassword = text
            }
        }
    }
    
    @IBOutlet private weak var loginPlaceholder: UIView! {
        didSet {
            let loginView: LabeledTextfield = .fromNib()
            loginPlaceholder.addSubview(loginView)
            loginView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loginView.leadingAnchor.constraint(equalTo: loginPlaceholder.leadingAnchor),
                loginView.trailingAnchor.constraint(equalTo: loginPlaceholder.trailingAnchor),
                loginView.topAnchor.constraint(equalTo: loginPlaceholder.topAnchor),
                loginView.bottomAnchor.constraint(equalTo: loginPlaceholder.bottomAnchor)
            ])
            loginView.configureLabeledTextfield(labelText: "Email")
            loginView.onSave = { [weak self] text in
                self?.userLogin = text
            }
        }
    }
    
    
    private enum Constant {
        static let registrationStoryboardName = "Registration"
        static let registrationViewControllerName = "RegistrationViewController"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func logInAction() {
        guard let userLogin, !userLogin.isEmpty, let userPassword, !userPassword.isEmpty  else {
            print("Something is empty!")
            return
        }
        
    }
    
    @IBAction private func signUpTapped() {
        let registrationStoryboard = UIStoryboard(name: Constant.registrationStoryboardName, bundle: nil)
        let registrationViewController = registrationStoryboard.instantiateViewController(withIdentifier: Constant.registrationViewControllerName) as! RegistrationViewController
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
}


