//
//  FavouritesViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: "FavouritesPostCell", bundle: .main)
            collectionView.register(nib, forCellWithReuseIdentifier: "FavouritesPostCell")
        }
    }
    
    private enum Constant {
        static let title = "Favourites"
        static let pointDetailsStoryboard = "PointDetailsViewController"
    }
    
    private let pointManager = PointManager.shared
    private var points: Array<Point>?
    private let firebaseManager = FirebaseManager.shared
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        configureHierarchy()
        collectionView.isHidden = true
        loadingLabel.isHidden = false
        
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            loadingLabel.text = "Log in to see your points"
            return
        }
        
        pointManager.getFavouritePointsForUser(userID: userId) { (allPoints, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                self.points = allPoints
                self.loadingLabel.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            collectionView.isHidden = true
            loadingLabel.isHidden = false
            loadingLabel.text = "Log in to see your points"
            return
        }
        
        loadingLabel.text = "Loading..."
        pointManager.getFavouritePointsForUser(userID: userId) { (allPoints, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                self.points = allPoints
                self.loadingLabel.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
    }
    
}

// MARK: - UICollectionViewDelegate

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pointDetailsStoryboard = UIStoryboard(name: Constant.pointDetailsStoryboard, bundle: nil)
        if let pointDetailsViewController = pointDetailsStoryboard.instantiateViewController(withIdentifier: String(describing: PointDetailsViewController.self)) as? PointDetailsViewController, let point = points?[indexPath.row] {
            pointDetailsViewController.selectedPoint(point: point)
            pointDetailsViewController.delegate = self
            present(pointDetailsViewController, animated: true, completion: nil)
        } else {
            fatalError("Unable to present PointDetailsViewController")
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return points?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesPostCell", for: indexPath) as? FavouritesPostCell, let point = points?[indexPath.row] {
            cell.cellConfigurate(point: point)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - PointDetailsViewControllerDelegate

extension FavouritesViewController: PointDetailsViewControllerDelegate {
    
    func pointWasDeleted() {
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            return
        }
        
        pointManager.getFavouritePointsForUser(userID: userId) { (allPoints, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                self.points = allPoints
                self.collectionView.reloadData()
            }
        }
    }
}

