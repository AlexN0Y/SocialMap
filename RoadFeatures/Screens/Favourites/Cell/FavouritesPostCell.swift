//
//  FavouritesPostCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 30.04.2023.
//

import UIKit

final class FavouritesPostCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var kindImage: UIImageView!
    
    // MARK: - Public Methods
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor(named: "inputs")!.cgColor
        }
    }
    
    func cellConfigurate(point: Point) {
        nameLabel.text = point.name
        
        if let city = point.city {
            cityLabel.isHidden = false
            cityLabel.text = city
        } else {
            cityLabel.isHidden = true
        }
        
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
}
