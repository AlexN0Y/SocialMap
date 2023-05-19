//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    private enum Constant {
        static let title = "Map"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        // plug
        let addLocationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [addLocationButton]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationAuthorization()
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        mapView.userTrackingMode = .follow
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func checkLocationAuthorization() {
        let locationManager = CLLocationManager()
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationServicesAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}
