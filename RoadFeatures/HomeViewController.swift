//
//  HomeViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Hello, man !"
    }
        // UserDefaults.standard.string(forKey: "username") ??

}
