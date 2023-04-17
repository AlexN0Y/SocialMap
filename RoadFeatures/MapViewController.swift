//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit

class MapViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel! {
        didSet {
            welcomeLabel.text = "Hello, man !"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        // UserDefaults.standard.string(forKey: "username") ??

}
