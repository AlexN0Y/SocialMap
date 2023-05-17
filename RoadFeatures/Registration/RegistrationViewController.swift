//
//  RegistrationViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private var userLogin: String?
    private var userPassword: String?
    private var userName: String?
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
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
    @IBOutlet private weak var namePlaceholder: UIView! {
        didSet {
            let nameView: LabeledTextfield = .fromNib()
            namePlaceholder.addSubview(nameView)
            nameView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                nameView.leadingAnchor.constraint(equalTo: namePlaceholder.leadingAnchor),
                nameView.trailingAnchor.constraint(equalTo: namePlaceholder.trailingAnchor),
                nameView.topAnchor.constraint(equalTo: namePlaceholder.topAnchor),
                nameView.bottomAnchor.constraint(equalTo: namePlaceholder.bottomAnchor)
            ])
            nameView.configureLabeledTextfield(labelText: "Name")
            nameView.onSave = { [weak self] text in
                self?.userName = text
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createUserName() {
        //        guard let name = nameField.text, let email = emailField.text, let password = passwordField.text else {
        //            return
        //        }
        //        UserDefaults.standard.set(name, forKey: "userName")
        //        UserDefaults.standard.set(email, forKey: "userEmail")
        //        UserDefaults.standard.set(password, forKey: "userPassword")
    }
    

}

