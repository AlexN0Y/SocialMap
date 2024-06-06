//
//  FavouritesViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var emptyImage: UIImageView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
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
    
    private var favouritesCount: Int = 0 {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.title
        configureHierarchy()
        collectionView.isHidden = true
        emptyLabel.isHidden = false
        emptyImage.isHidden = false
        
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            emptyLabel.text = "Nothing here? Login to see your favourites!"
            return
        }
        
        pointManager.getFavouritePointsForUser(userID: userId) { [weak self] (allPoints, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error("Error occured"))
                print("Failed to get points:", error)
            } else if let allPoints {
                points = allPoints
                favouritesCount = allPoints.count
                emptyLabel.isHidden = true
                emptyImage.isHidden = true
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        }
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            collectionView.isHidden = true
            emptyImage.isHidden = false
            emptyLabel.isHidden = false
            emptyLabel.text = "Nothing here? Login to see your favourites!"
            return
        }
        
        emptyLabel.text = "It's empty for now, mark your favorite places!"
        
        pointManager.getFavouritePointsForUser(userID: userId) { [weak self] (allPoints, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error("Error occured"))
                print("Failed to get points:", error)
            } else if let allPoints {
                points = allPoints
                favouritesCount = allPoints.count
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        let isEmptyState = favouritesCount == 0
        
        collectionView.isHidden = isEmptyState
        emptyImage.isHidden = !isEmptyState
        emptyLabel.isHidden = !isEmptyState
    }
    
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
#warning("Rewrite Logic for instantinateVC")
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return points?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
        
        pointManager.getFavouritePointsForUser(userID: userId) { [weak self] (allPoints, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error("Error occured"))
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                points = allPoints
                favouritesCount = allPoints.count
                collectionView.reloadData()
            }
        }
    }
}

