//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit

class MapViewController: UIViewController {
    @IBOutlet private weak var welcomeLabel: UILabel! {
        didSet {
            welcomeLabel.text = "Hello, map will be soon !"
        }
    }
    
    private enum Constant {
        static let title = "Map"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
}
