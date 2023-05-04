//
//  PointDetailsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 01.05.2023.
//

import UIKit

class PointDetailsViewController: UIViewController {
    private var point: Point?
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var kindImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        setOutlets()
    }
    
    private func setOutlets() {
        guard let point = point else {
            return
        }
        nameLabel.text = point.name
        cityLabel.text = point.city ?? "None"
        descriptionLabel.text = point.description ?? "None"
        pointLabel.text = "X: \(point.point.0), Y: \(point.point.1)"
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
    
    func selectedPoint(point: Point) {
        self.point = point
    }

}
