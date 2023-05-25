//
//  PointDetailsViewController.swift
//  RoadFeatures
//
//  Created by Alex Gav on 01.05.2023.
//

import UIKit

protocol PointDetailsViewControllerDelegate: AnyObject {
    func pointWasDeleted()
}

class PointDetailsViewController: UIViewController {
    weak var delegate: PointDetailsViewControllerDelegate?
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
        pointLabel.text = "X: \(point.point.0) \n Y: \(point.point.1)"
        kindImage.image = UIImage(named: point.kind.rawValue)
    }
    
    func selectedPoint(point: Point) {
        self.point = point
    }
    
    @IBAction private func deletePoint() {
        guard let point = point else {
            return
        }
        let pointManager = PointManager.shared
        pointManager.remove(point: point)
        delegate?.pointWasDeleted()
        dismiss(animated: true, completion: nil)
    }
    
}
