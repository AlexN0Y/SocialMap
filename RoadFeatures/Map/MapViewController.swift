//
//  MapViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 26.03.2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private let locationManager = LocationManager()
    private let pointManager = PointManager.shared
    private var points: [Point]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    private enum Constant {
        static let title = "Map"
        static let addPointStoryboard = "AddPointViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.locationDelegate = self
        let addLocationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLocationTapped(_:)))
        navigationItem.rightBarButtonItems = [addLocationButton]
        setAnnotations()
    }
    
    private func setAnnotations() {
        pointManager.getAllFromDatabase { (points, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let points = points {
                self.points = points
                var annotations = [MKPointAnnotation]()
                for point in points {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: point.point.0, longitude: point.point.1)
                    annotation.title = point.name
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
        }
    }
    
    @objc private func addLocationTapped(_ sender: UIBarButtonItem) {
        let addPointStoryboard = UIStoryboard(name: Constant.addPointStoryboard, bundle: nil)
        let addPointViewController = addPointStoryboard.instantiateViewController(withIdentifier: String(describing: AddPointViewController.self)) as! AddPointViewController
        addPointViewController.hidesBottomBarWhenPushed = true
        addPointViewController.delegate = self
        self.navigationController?.pushViewController(addPointViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.checkLocationAuthorization()
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

extension MapViewController: AddPointViewControllerDelegate {
    func pointWasAdded(pointID: String) {
        pointManager.getPointByID(id: pointID) { (point, error) in
            if let error = error {
                print("Failed to get point with id \(pointID):", error)
            } else if let point = point {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: point.point.0, longitude: point.point.1)
                annotation.title = point.name
                self.mapView.addAnnotation(annotation)
            }
        }

    }
}
