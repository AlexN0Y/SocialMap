//
//  FavouritesViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

struct Point {
    enum Kind: String {
        case building = "BuildingImage"
        case park = "ParkImage"
    }
    let name: String
    let description: String? // може не бути
    let city: String? // може не бути
    let kind: Kind
    let point: (Int, Int)
}

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet private weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private enum Constant {
        static let title = "Favourites"
        static let pointDetailsStoryboard = "PointDetailsViewController"
    }
    
    let points: Array<Point> = [
        Point(name: "Empire State Building", description: "A famous skyscraper in New York City A famous skyscraper in New York City A famous skyscraper in New York City", city: "New York", kind: .building, point: (40, -73)),
        Point(name: "Central Park", description: "A large park in New York City", city: "New York", kind: .park, point: (40, -73)),
        Point(name: "Big Ben", description: "A famous clock tower in London", city: "London", kind: .building, point: (51, -0)),
        Point(name: "Hyde Park", description: "A large park in London", city: "London", kind: .park, point: (51, -0)),
        Point(name: "Eiffel Tower", description: "A famous tower in Paris", city: "Paris", kind: .building, point: (48, 2)),
        Point(name: "Big Ben", description: "A famous clock tower in London", city: "London", kind: .building, point: (51, -0))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        setSpaceBetweenCells()
    }
    
    private func setSpaceBetweenCells() {
        let layout = favouritesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 15
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return points.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! FavouritesPostCell
        cell.cellConfigurate(point: points[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pointDetailsStoryboard = UIStoryboard(name: Constant.pointDetailsStoryboard, bundle: nil)
        let pointDetailsViewController = pointDetailsStoryboard.instantiateViewController(withIdentifier: String(describing: PointDetailsViewController.self)) as! PointDetailsViewController
        pointDetailsViewController.selectedPoint(point: points[indexPath.row])
        present(pointDetailsViewController, animated: true, completion: nil)
    }

    
}

