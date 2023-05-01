//
//  FavouritesPostCell.swift
//  RoadFeatures
//
//  Created by Alex Gav on 30.04.2023.
//

import UIKit

class FavouritesPostCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var kindImage: UIImageView!
    
    func cellConfigurate(point: Point) {
        nameLabel.text = point.name
        cityLabel.text = point.city ?? ""
        descriptionLabel.text = point.description ?? ""
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
}
