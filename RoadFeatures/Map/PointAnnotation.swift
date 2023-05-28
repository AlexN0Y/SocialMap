//
//  PointAnnotation.swift
//  RoadFeatures
//
//  Created by Alex Gav on 28.05.2023.
//

import MapKit

class PointAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var point: Point
    
    init(point: Point) {
        self.coordinate = CLLocationCoordinate2D(latitude: point.point.0, longitude: point.point.1)
        self.title = point.name
        self.point = point
    }
}
