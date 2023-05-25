//
//  Point.swift
//  RoadFeatures
//
//  Created by Alex Gav on 22.05.2023.
//

import Foundation

struct Point {
    enum Kind: String, CaseIterable {
        case building = "BuildingImage"
        case park = "ParkImage"
    }
    let index: Int
    let name: String
    let description: String?
    let city: String?
    let kind: Kind
    let point: (Double, Double)
    // owner, rating, image/s
    
}
