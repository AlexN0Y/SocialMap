//
//  LoginViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.03.2023.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    var fromRegistration = false
    
    // MARK: - Private Properties
    
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
                labelText: String(localized: "Password"),
                textFieldType: .password,
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
                labelText: String(localized: "Email"),
                textFieldType: .email,
                keyboardType: .emailAddress,
                placeholder: "example@gmail.com"
            )
            loginView.onSave = { [weak self] text in
                self?.userLogin = text
            }
        }
    }
    
    private enum Constant {
        
        static let registrationStoryboardName = "Registration"
        static let registrationViewControllerName = "RegistrationViewController"
    }
    
    private var userLogin: String?
    private var userPassword: String?
    
    private let firebaseManager = FirebaseManager.shared
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Private Methods
    
    
    @IBAction private func didTapRegistration() {
        if fromRegistration {
            navigationController?.popViewController(animated: true)
        } else {
            let registrationStoryboard = UIStoryboard(
                name: Constant.registrationStoryboardName,
                bundle: nil
            )
            
            let registrationViewController = registrationStoryboard.instantiateViewController(
                withIdentifier: Constant.registrationViewControllerName
            ) as! RegistrationViewController
            
            registrationViewController.fromLogin = true
            
            navigationController?.pushViewController(registrationViewController, animated: true)
        }
    }
    
    @IBAction private func logInAction() {
        guard let userLogin, !userLogin.isEmpty, let userPassword, !userPassword.isEmpty  else {
            showEmptyFieldsAlert()
            return
        }
        HUD.present(type: .loader)
        
        firebaseManager.logIn(
            withEmail: userLogin,
            password: userPassword
        ) { [weak self] authResult, error in
            guard let self else { return }
            HUD.dismiss()
            
            if let error = error {
                showUserDoesNotExistsAlert()
                print("Login failed: \(error.localizedDescription)")
            } else {
                HUD.present(type: .success(String(localized: "Successful login")))
                print("Login successful for user: \(authResult?.user.email ?? "")")
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @objc
    private func handleTap() {
        view.endEditing(true)
    }
    
    private func showEmptyFieldsAlert() {
        let alert = UIAlertController(
            title: String(localized: "Alert"),
            message: String(localized: "Fill in all the fields"),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showUserDoesNotExistsAlert() {
        let alert = UIAlertController(
            title: String(localized: "Alert"),
            message: String(localized: "User does not exists"),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
