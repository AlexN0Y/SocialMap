//
//  FavouritesViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

final class FavouritesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var emptyImage: UIImageView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            let nib = UINib(nibName: "FavouritesPostCell", bundle: .main)
            collectionView.register(nib, forCellWithReuseIdentifier: "FavouritesPostCell")
        }
    }
    
    private let pointManager = PointManager.shared
    private var points: [Point]?
    private let firebaseManager = FirebaseManager.shared
    private let lineSpace: CGFloat = 12
    private let cellHeight: CGFloat = 80
    
    private var favouritesCount: Int = 0 {
        didSet { updateUI() }
    }
    
    private enum Constant {
        static let title = String(localized: "Favourites")
        static let pointDetailsStoryboard = "PointDetailsViewController"
    }
    
    // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.title
        configureCollectionView()
        emptyLabel.isHidden = false
        emptyImage.isHidden = false
        
        guard let userId = firebaseManager.getCurrentUser()?.uid else {
            emptyLabel.text = String(localized: "Nothing here? Login to see your favourites!")
            return
        }
        
        pointManager.getFavouritePointsForUser(userID: userId) { [weak self] (allPoints, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
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
            emptyLabel.text = String(localized: "Nothing here? Login to see your favourites!")
            return
        }
        
        emptyLabel.text = String(localized: "It's empty for now, mark your favorite places!")
        
        pointManager.getFavouritePointsForUser(userID: userId) { [weak self] (allPoints, error) in
            guard let self else { return }
            
            if let error = error {
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Failed to get points:", error)
            } else if let allPoints {
                points = allPoints
                favouritesCount = allPoints.count
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func configureCollectionView() {
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(
            top: 30,
            left: 0,
            bottom: 30,
            right: 0
        )
    }
    
    private func updateUI() {
        let isEmptyState = favouritesCount == 0
        
        collectionView.isHidden = isEmptyState
        emptyImage.isHidden = !isEmptyState
        emptyLabel.isHidden = !isEmptyState
    }
}

// MARK: - UICollectionViewDelegate

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let pointDetailsStoryboard = UIStoryboard(name: Constant.pointDetailsStoryboard, bundle: nil)
        if let pointDetailsViewController = pointDetailsStoryboard.instantiateViewController(
            withIdentifier: String(describing: PointDetailsViewController.self)) as? PointDetailsViewController,
            let point = points?[indexPath.row]
        {
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
        points?.count ?? 0
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

// MARK: - UICollectionViewDelegateFlowLayout

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: cellHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        lineSpace
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
                HUD.present(type: .error(String(localized: "Error occured")))
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                points = allPoints
                favouritesCount = allPoints.count
                collectionView.reloadData()
            }
        }
    }
}
