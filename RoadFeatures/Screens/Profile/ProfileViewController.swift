//
//  ProfileViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 21.05.2024.
//

import UIKit

final class ProfileViewController: UIViewController, NibLoadable {
    
    private let firebaseManager = FirebaseManager.shared
    
    @IBAction private func didTapSignOut() {
        do {
            try firebaseManager.signOut()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
