//
//  AccountLogInViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 05.02.2024.
//

import UIKit

class AccountLogInViewController: UIViewController, NibLoadable {
    
    var onTapRegistration: (() -> Void)?
    var onTapLogIn: (() -> Void)?
    
    @IBAction func registrationButtonTapped() {
        onTapRegistration?()
    }
    
    @IBAction func logInButtonTapped() {
        onTapLogIn?()
    }
}
