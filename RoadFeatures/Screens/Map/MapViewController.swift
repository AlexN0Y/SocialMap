//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
    }
    
    private let locationManager = LocationManager()
    private let pointManager = PointManager.shared
    private var points: [Point]?
    private let firebaseManager = FirebaseManager.shared
    
    private enum Constant {
        
        static let addPointStoryboard = "AddPointViewController"
        static let pointDetailsStoryboard = "PointDetailsViewController"
    }
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.locationDelegate = self
        setAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeAnnotations()
        setAnnotations()
        locationManager.checkLocationAuthorization()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private Methods
    
    @IBAction private func addLocationTapped() {
        guard let _ = firebaseManager.getCurrentUser() else {
            showNotAuthorisedAlert()
            return
        }
        
        let addPointStoryboard = UIStoryboard(name: Constant.addPointStoryboard, bundle: nil)
        let addPointViewController = addPointStoryboard.instantiateViewController(withIdentifier: String(describing: AddPointViewController.self)) as! AddPointViewController
        addPointViewController.hidesBottomBarWhenPushed = true
        addPointViewController.delegate = self
        navigationController?.pushViewController(addPointViewController, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction private func centerMapTapped() {
        guard let location = locationManager.getCurrentLocationCoordinate() else { return }
        let region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    private func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func setAnnotations() {
        pointManager.getAllFromDatabase { [weak self] (points, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Failed to get points:", error)
            } else if let points {
                self.points = points
                var annotations = [PointAnnotation]()
                for point in points {
                    let annotation = PointAnnotation(point: point)
                    annotations.append(annotation)
                }
                
                mapView.addAnnotations(annotations)
            }
        }
    }
    
    private func showLocationServicesAlert() {
        let alert = UIAlertController(
            title: String(localized: "Location Services Disabled"),
            message: String(localized: "Please enable location services to use this feature."),
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(
            title: String(localized: "Settings"),
            style: .default
        ) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(
            title: String(localized: "Cancel"),
            style: .cancel, handler: nil
        )
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showNotAuthorisedAlert() {
        presentAlert(message: String(localized: "Log in to add"))
    }
    
    private func presentAlert(
        message: String
    ) {
        let alert = UIAlertController(
            title: String(localized: "Alert"),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? PointAnnotation {
            let pointDetailsStoryboard = UIStoryboard(name: Constant.pointDetailsStoryboard, bundle: nil)
            if let pointDetailsViewController = pointDetailsStoryboard.instantiateViewController(withIdentifier: String(describing: PointDetailsViewController.self)) as? PointDetailsViewController {
                pointDetailsViewController.selectedPoint(point: annotation.point)
                pointDetailsViewController.delegate = self
                present(pointDetailsViewController, animated: true, completion: nil)
            } else {
                fatalError("Unable to present PointDetailsViewController")
            }
        }
    }
}

// MARK: - LocationDelegate

extension MapViewController: LocationDelegate {
    
    func locationDidUpdate(to location: CLLocation) {}
    
    func locationDidFail(withError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationServicesWereDenied() {
        showLocationServicesAlert()
    }
}

// MARK: - AddPointViewControllerDelegate

extension MapViewController: AddPointViewControllerDelegate {
    
    func pointWasAdded(pointID: String) {
        pointManager.getPointByID(id: pointID) { [weak self] (point, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Failed to get point with id \(pointID):", error)
            } else if let point {
                let annotation = PointAnnotation(point: point)
                mapView.addAnnotation(annotation)
            }
        }
    }
}

// MARK: - PointDetailsViewControllerDelegate

extension MapViewController: PointDetailsViewControllerDelegate {
    
    func pointWasDeleted() {
        removeAnnotations()
        setAnnotations()
    }
}
