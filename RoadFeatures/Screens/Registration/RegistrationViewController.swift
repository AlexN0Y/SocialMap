//
//  RegistrationViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Private Properties
    
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
            passwordView.configureLabeledTextfield(
                labelText: "Password",
                secureTextEntry: true,
                placeholder: "***********"
            )
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
            loginView.configureLabeledTextfield(
                labelText: "Email",
                keyboardType: .emailAddress,
                placeholder: "example@gmail.com"
            )
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
            nameView.configureLabeledTextfield(
                labelText: "Name",
                placeholder: "Alex"
            )
            
            nameView.onSave = { [weak self] text in
                self?.userName = text
            }
        }
    }
    
    private var userLogin: String?
    private var userPassword: String?
    private var userName: String?
    
    private let firebaseManager = FirebaseManager.shared
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    
    @objc 
    private func handleTap() {
        view.endEditing(true)
    }
    
    private func showEmptyFieldsAlert() {
        let alert = UIAlertController(title: "Alert", message: "Fill in all the fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showEmailAlert() {
        let alert = UIAlertController(title: "Alert", message: "The email address is badly formatted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction private func createUser() {
        guard let name = userName, !name.isEmpty, let email = userLogin, !email.isEmpty, let password = userPassword, !password.isEmpty else {
            showEmptyFieldsAlert()
            return
        }
        firebaseManager.createUser(withEmail: email, password: password, userName: name) { [weak self] error in
            if error != nil {
                self?.showEmailAlert()
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

