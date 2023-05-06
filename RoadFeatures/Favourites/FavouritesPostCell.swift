//
//  FavouritesPostCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 30.04.2023.
//

import UIKit

class FavouritesPostCell: UICollectionViewCell {
    var point: Point?
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var kindImage: UIImageView!
    
    func cellConfigurate(point: Point) {
        self.point = point
        nameLabel.text = point.name
        if let city = point.city {
            cityLabel.isHidden = false
            cityLabel.text = city
        } else {
            cityLabel.isHidden = true
        }
        if let description = point.description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
        
}
