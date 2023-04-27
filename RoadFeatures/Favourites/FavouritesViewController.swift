//
//  FavouritesViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 16.04.2023.
//

import UIKit

struct Point {
    enum Kind: String {
        case building = "Building"
        case park = "Park"
    }
    let name: String
    let descriprion: String
    let city: String
    let kind: Kind
    let point: (Int, Int)
}

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private enum Constant {
        static let title = "Favourites"
    }
    
    let points: Array<Point> = [
        Point(name: "Empire State Building", descriprion: "A famous skyscraper in New York City", city: "New York", kind: .building, point: (40, -73)),
        Point(name: "Central Park", descriprion: "A large park in New York City", city: "New York", kind: .park, point: (40, -73)),
        Point(name: "Big Ben", descriprion: "A famous clock tower in London", city: "London", kind: .building, point: (51, -0)),
        Point(name: "Hyde Park", descriprion: "A large park in London", city: "London", kind: .park, point: (51, -0)),
        Point(name: "Eiffel Tower", descriprion: "A famous tower in Paris", city: "Paris", kind: .building, point: (48, 2))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return points.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.nameLabel.text = points[indexPath.row].name
        cell.cityLabel.text = points[indexPath.row].city
        cell.descriptionLabel.text = points[indexPath.row].descriprion
        cell.kindLabel.text = points[indexPath.row].kind.rawValue
        return cell
    }
    
    
}


class PostCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    
}
