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

final class PointDetailsViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: PointDetailsViewControllerDelegate?
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var kindImage: UIImageView!
    
    @IBOutlet private weak var addRemoveButton: UIButton! {
        didSet { updateFavoriteButton() }
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
    
    private enum State {
        case addedToFavourites
        case notInFavourites
    }
    
    private var point: Point?
    private let pointManager = PointManager.shared
    private let firebaseManager = FirebaseManager.shared
    private var state: State = .notInFavourites
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(localized: "Details")
        setOutlets()
    }
    
    // MARK: - Public Methods
    
    func selectedPoint(point: Point) {
        self.point = point
    }
    
    // MARK: - Private Methods
    
    @IBAction private func addRemoveButtonTapped() {
        switch(state) {
        case .addedToFavourites:
            removeFromFavourites()
        case .notInFavourites:
            addToFavourites()
        }
    }
    
    @IBAction private func deletePoint() {
        guard let point = point else {
            return
        }
        
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            return
        }
        
        guard point.owner == userId else {
            showAlert()
            return
        }
        
        pointManager.removePointFromFavourites(userID: userId, pointID: point.id){ error in
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Error removing point: \(error)")
            } else {
                print("Point successfully deleted from favourites.")
            }
        }
        
        pointManager.remove(point: point) { error in
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Error removing point: \(error)")
            } else {
                print("Point successfully deleted.")
                self.delegate?.pointWasDeleted()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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
        
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
    
    private func addToFavourites() {
        guard let userID = firebaseManager.getCurrentUser()?.uid, let point = point else {
            return
        }
        
        pointManager.addFavouritePointToUser(userID: userID, point: point) { error in
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Failed to add favourite point: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func removeFromFavourites() {
        guard 
            let userID = firebaseManager.getCurrentUser()?.uid,
            let point = point
        else {
            return
        }
        
        pointManager.removePointFromFavourites(userID: userID, pointID: point.id) { error in
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
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
        let alert = UIAlertController(
            title: String(localized: "Alert"),
            message: String(localized: "You are not an owner"),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func updateFavoriteButton() {
        guard let userID = firebaseManager.getCurrentUser()?.uid, let point = point else {
            addRemoveButton.isHidden = true
            return
        }
        
        addRemoveButton.setTitle("", for: .normal)
        addRemoveButton.isHidden = false
        pointManager.checkIfPointIsFavourite(
            userID: userID,
            pointID: point.id
        ) { [weak self] (isFavourite, error) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    HUD.present(type: .error(String(localized: "Error occured")))
                    print("Error checking if point is favourite: \(error)")
                } else {
                    self.updateButtonAppearance(isFavourite: isFavourite ?? false)
                }
            }
        }
    }
    
    private func updateButtonAppearance(isFavourite: Bool) {
        let imageName = isFavourite ? "star.fill" : "star"
        addRemoveButton.setImage(UIImage(systemName: imageName), for: .normal)
        state = isFavourite ? .addedToFavourites : .notInFavourites
    }
}
