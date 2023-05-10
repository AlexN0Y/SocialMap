//
//  FavouritesPostCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 30.04.2023.
//

import UIKit

class FavouritesPostCell: UICollectionViewCell {
    @IBOutlet private  var nameLabel: UILabel!
    @IBOutlet private  var cityLabel: UILabel!
    @IBOutlet private  var descriptionLabel: UILabel!
    @IBOutlet private  var kindImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cellConfigurate(point: Point) {
        //self.point = point
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
