//
//  AboutAuthorsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 25.05.2024.
//

import UIKit

final class AboutAuthorsViewController: UIViewController, NibLoadable {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "About Authors")
    }
    
    @IBAction private func didTapDeveloper(_ sender: Any) {
        if let url = URL(string: "https://www.instagram.com/nelomany") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
