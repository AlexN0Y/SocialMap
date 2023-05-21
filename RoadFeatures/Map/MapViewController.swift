//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let locationManager = LocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    private enum Constant {
        static let title = "Map"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.locationDelegate = self
        // plug
        let addLocationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addLocationButton]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.checkLocationAuthorization()
    }
    
    func showLocationServicesAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services to use this feature.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension MapViewController: MKMapViewDelegate {
}

extension MapViewController: LocationDelegate {
    func locationDidUpdate(to location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        mapView.userTrackingMode = .follow
    }
    
    func locationDidFail(withError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationServicesWereDenied() {
        showLocationServicesAlert()
    }
}
