//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
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
        
        static let title = "Map"
        static let addPointStoryboard = "AddPointViewController"
        static let pointDetailsStoryboard = "PointDetailsViewController"
    }
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        locationManager.locationDelegate = self
        let addLocationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLocationTapped(_:)))
        navigationItem.rightBarButtonItems = [addLocationButton]
        setAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        removeAnnotations()
        setAnnotations()
        locationManager.checkLocationAuthorization()
    }
    
    // MARK: - Private Methods
    
    private func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func setAnnotations() {
        pointManager.getAllFromDatabase { (points, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let points = points {
                self.points = points
                var annotations = [PointAnnotation]()
                for point in points {
                    let annotation = PointAnnotation(point: point)
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    @objc
    private func addLocationTapped(_ sender: UIBarButtonItem) {
        let addPointStoryboard = UIStoryboard(name: Constant.addPointStoryboard, bundle: nil)
        let addPointViewController = addPointStoryboard.instantiateViewController(withIdentifier: String(describing: AddPointViewController.self)) as! AddPointViewController
        addPointViewController.hidesBottomBarWhenPushed = true
        addPointViewController.delegate = self
        self.navigationController?.pushViewController(addPointViewController, animated: true)
    }
    
    private func showLocationServicesAlert() {
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
    
    func locationDidUpdate(to location: CLLocation) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        
        mapView.setRegion(region, animated: true)
        mapView.userTrackingMode = .follow
    }
    
    func locationDidFail(withError error: Error) {
#warning("Add Alert !")
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationServicesWereDenied() {
        showLocationServicesAlert()
    }
}

// MARK: - AddPointViewControllerDelegate

extension MapViewController: AddPointViewControllerDelegate {
    
    func pointWasAdded(pointID: String) {
        pointManager.getPointByID(id: pointID) { (point, error) in
            if let error = error {
                print("Failed to get point with id \(pointID):", error)
            } else if let point = point {
                let annotation = PointAnnotation(point: point)
                self.mapView.addAnnotation(annotation)
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
