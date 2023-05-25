//
//  PointManager.swift
//  RoadFeatures
//
//  Created by Alex Gav on 24.05.2023.
//

import Foundation

class PointManager {
    static let shared = PointManager()
    private var points: [Point]
    private var index: Int
    
    init() {
        points =  [
            Point(index: 1, name: "Empire State Building AAAAAAAA", description: "A famous skyscraper in New York City A famous skyscraper in New York City A famous skyscraper in New York City", city: "New York aaaaa aaaaa aaaa", kind: .building, point: (40.748817, -73.985428)),
            Point(index: 2, name: "Central Park", description: "A large park in New York City", city: "New York", kind: .park, point: (40, -73)),
            Point(index: 3, name: "Big Ben", description: "A famous clock tower in London", city: "London", kind: .building, point: (51.510357, -0.116773)),
            Point(index: 4, name: "Hyde Park", description: "A large park in London", city: "London", kind: .park, point: (51, -0)),
            Point(index: 5, name: "Eiffel Tower", description: "A famous tower in Paris", city: "Paris", kind: .building, point: (48, 2)),
            Point(index: 6, name: "Feature point", description: nil, city: nil, kind: .park, point: (48.621025, 22.288229)),
            Point(index: 7, name: "Big Ben", description: "A famous clock tower in London", city: "London", kind: .building, point: (51, -0))
        ]
        index = points.last?.index ?? 1
    }
    
    
    
    func getAll() -> [Point] {
        return points
    }
    
    func add(name: String, description: String?, city: String?, kind: Point.Kind, point: (Double, Double)) {
        index += 1
        points.append(Point(index: index, name: name, description: description, city: city, kind: kind, point: point))
    }
    
    func remove(point: Point) {
        points.removeAll { $0.index == point.index }
    }
}
