//
//  FavouritesPostCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 30.04.2023.
//

import UIKit

class FavouritesPostCell: UICollectionViewCell {
    @IBOutlet private  var nameLabel: UILabel! {
        didSet {
            nameLabel.font = UIFont(name: "Helvetica-Bold", size: 19)
        }
    }
    @IBOutlet private  var cityLabel: UILabel! {
        didSet {
            cityLabel.font = UIFont(name: "Helvetica", size: 18)
        }
    }
    @IBOutlet private  var descriptionLabel: UILabel!
    @IBOutlet private  var kindImage: UIImageView!
    
    
    func cellConfigurate(point: Point) {
        descriptionLabel.backgroundColor = UIColor.white
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
