//
//  SettingsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var signInOutButton: UIButton!
    private enum Constant {
        static let title = "Settings"
        static let logInStoryboardName = "LogIn"
        static let logInViewControllerName = "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let usersCollection = db.collection("users")
            let userDocument = usersCollection.document(user.uid)
            userDocument.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let name = document.data()?["name"] as? String {
                        self.greetingLabel.isHidden = false
                        self.greetingLabel.text = "Welcome \(name)"
                    } else {
                        print("Name field does not exist or is not of type String")
                    }
                } else {
                    print("User document does not exist or there was an error: \(error?.localizedDescription ?? "")")
                }
            }
            signInOutButton.setTitle("LogOut", for: .normal)
        } else {
            signInOutButton.setTitle("LogIn", for: .normal)
            greetingLabel.isHidden = true
        }
    }
    
    @IBAction private func logInTapped() {
        switch(signInOutButton.titleLabel?.text) {
        case "LogIn":
            let logInStoryboard = UIStoryboard(name: Constant.logInStoryboardName, bundle: nil)
            let logInViewController = logInStoryboard.instantiateViewController(withIdentifier: Constant.logInViewControllerName) as! LoginViewController
            logInViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(logInViewController, animated: true)
        case "LogOut":
            do {
                try Auth.auth().signOut()
                greetingLabel.isHidden = true
                signInOutButton.setTitle("LogIn", for: .normal)
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        default:
            fatalError("Button doesn't have title")
        }
    }
    
    
}
