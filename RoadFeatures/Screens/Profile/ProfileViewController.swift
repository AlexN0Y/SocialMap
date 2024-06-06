//
//  ProfileViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.05.2024.
//

import UIKit

final class ProfileViewController: UIViewController, NibLoadable {
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    private let firebaseManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        guard let currentUser = firebaseManager.getCurrentUser() else { return }
        nameLabel.text = currentUser.displayName
    }
    
    @IBAction private func didTapSignOut() {
        do {
            try firebaseManager.signOut()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            HUD.present(type: .error("Error occured"))
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
