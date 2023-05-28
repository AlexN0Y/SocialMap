//
//  FavouritesViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

class FavouritesViewController: UIViewController {
    
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
        static let addPointStoryboard = "AddPointViewController"
    }
    private let pointManager = PointManager.shared
    private var points: Array<Point>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        configureHierarchy()
        collectionView.isHidden = true
        loadingLabel.isHidden = false
        pointManager.getAllFromDatabase { (allPoints, error) in
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
        pointManager.getAllFromDatabase { (allPoints, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                self.points = allPoints
                self.collectionView.reloadData()
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
    }
    
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension FavouritesViewController: PointDetailsViewControllerDelegate {
    func pointWasDeleted() {
        pointManager.getAllFromDatabase { (allPoints, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                self.points = allPoints
                self.collectionView.reloadData()
            }
        }
    }
}

