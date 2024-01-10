//
//  SettingsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var signInOutButton: UIButton!
    
    private enum Constant {
        static let title = "Settings"
        static let logInStoryboardName = "LogIn"
        static let logInViewControllerName = "LoginViewController"
    }
    
    private enum State {
        case loggedIn
        case guest
    }
    
    private var state: State = .guest
    
    private let firebaseManager = FirebaseManager.shared
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = firebaseManager.getCurrentUser() {
            firebaseManager.getUserDetails(uid: user.uid) { document, error in
                if let error = error {
                    print("User document does not exist or there was an error: \(error.localizedDescription)")
                } else if 
                    let document = document, let name = document["name"] as? String {
                    self.greetingLabel.isHidden = false
                    self.greetingLabel.text = "Welcome \(name)"
                } else {
                    print("Name field does not exist or is not of type String")
                }
            }
            
            state = .loggedIn
            signInOutButton.setTitle("LogOut", for: .normal)
        } else {
            state = .guest
            signInOutButton.setTitle("LogIn", for: .normal)
            greetingLabel.isHidden = true
        }
    }
    
    // MARK: - Private Properties
    
    @IBAction private func logInTapped() {
        switch(state) {
        case .guest:
            let logInStoryboard = UIStoryboard(name: Constant.logInStoryboardName, bundle: nil)
            let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: Constant.logInViewControllerName) as! LoginViewController
            logInViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logInViewController, animated: true)
            
        case .loggedIn:
            do {
                try firebaseManager.signOut()
                greetingLabel.isHidden = true
                signInOutButton.setTitle("LogIn", for: .normal)
                state = .guest
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }
    }
    
}
