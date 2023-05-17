//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private enum Constant {
        static let title = "Map"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
}

extension MapViewController: MKMapViewDelegate {
}
