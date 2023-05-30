//
//  PointDetailsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 01.05.2023.
//

import UIKit

protocol PointDetailsViewControllerDelegate: AnyObject {
    func pointWasDeleted()
}

class PointDetailsViewController: UIViewController {
    weak var delegate: PointDetailsViewControllerDelegate?
    private var point: Point?
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var kindImage: UIImageView!
    @IBOutlet private weak var handleView: UIView!{
        didSet {
            handleView.layer.cornerRadius = 5
            handleView.backgroundColor = .gray
        }
    }
    @IBOutlet private weak var addRemoveButton: UIButton! {
        didSet {
            if let userID = firebaseManager.getCurrentUser()?.uid, let point = point {
                addRemoveButton.isHidden = false
                pointManager.checkIfPointIsFavourite(userID: userID, pointID: point.id) { (isFavourite, error) in
                    if let error = error {
                        print("Error checking if point is favourite: \(error)")
                    } else if let isFavourite = isFavourite {
                        if isFavourite {
                            self.addRemoveButton.setTitle("Remove from favourites", for: .normal)
                            self.addRemoveButton.setTitleColor(.red, for: .normal)
                            self.state = .addedToFavourites
                        } else {
                            self.addRemoveButton.setTitle("Add to favourites", for: .normal)
                            self.addRemoveButton.setTitleColor(.blue, for: .normal)
                            self.state = .notInFavourites
                        }
                    }
                }
            } else {
                addRemoveButton.isHidden = true
            }
 
        }
    }
    @IBOutlet private weak var deleteButton: UIButton! {
        didSet {
            if point?.owner == firebaseManager.getCurrentUser()?.uid {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
        }
    }
    private let pointManager = PointManager.shared
    private let firebaseManager = FirebaseManager.shared
    private enum State {
        case addedToFavourites
        case notInFavourites
    }
    private var state: State = .notInFavourites
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        setOutlets()
    }
    
    private func setOutlets() {
        guard let point = point else {
            return
        }
        nameLabel.text = point.name
        if let city = point.city, !city.isEmpty {
            cityLabel.text = city
        } else {
            cityLabel.text = "None"
        }
        if let description = point.description, !description.isEmpty {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = "None"
        }
        pointLabel.text = "X: \(String(format: "%.10f", point.point.0)) \n Y: \(String(format: "%.10f", point.point.1))"
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
    
    func selectedPoint(point: Point) {
        self.point = point
    }
    
    @IBAction private func addRemoveButtonTapped() {
        switch(state) {
        case .addedToFavourites:
            removeFromFavourites()
        case .notInFavourites:
            addToFavourites()
        }
    }
    
    private func addToFavourites() {
        guard let userID = firebaseManager.getCurrentUser()?.uid, let point = point else {
            return
        }
        pointManager.addFavouritePointToUser(userID: userID, point: point) { error in
            if let error = error {
                print("Failed to add favourite point: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func removeFromFavourites() {
        guard let userID = firebaseManager.getCurrentUser()?.uid, let point = point else {
            return
        }
        pointManager.removePointFromFavourites(userID: userID, pointID: point.id) { error in
            if let error = error {
                print("Error removing point from favourites: \(error.localizedDescription)")
            } else {
                self.delegate?.pointWasDeleted()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    
    private func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "You are not an owner", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction private func deletePoint() {
        guard let point = point else {
            return
        }
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            return
        }
        if point.owner == userId {
            pointManager.removePointFromFavourites(userID: userId, pointID: point.id){ error in
                if let error = error {
                    print("Error removing point: \(error)")
                } else {
                    print("Point successfully deleted from favourites.")
                }
            }
            pointManager.remove(point: point) { error in
                if let error = error {
                    print("Error removing point: \(error)")
                } else {
                    print("Point successfully deleted.")
                    self.delegate?.pointWasDeleted()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            showAlert()
        }
    }
    
}
