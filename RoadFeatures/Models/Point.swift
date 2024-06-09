//
//  Point.swift
//  RoadFeatures
//
//  Created by Alex Gav on 22.05.2023.
//

import Foundation

struct Point {
    
    // MARK: - Enum Kind
    
    enum Kind: String, CaseIterable {
        
        // MARK: - Cases
        
        case restaurant = "Restaurant"
        case cafe = "Cafe"
        case park = "Park"
        case bench = "Bench"
        case club = "Club"
        case shoppingCentre = "ShoppingCentre"
        case store = "Store"
        case hotel = "Hotel"
        case pharmacy = "Pharmacy"
        case monument = "Monument"
        
        var title: String {
            switch self {
            case .restaurant:
                String(localized: "Restaurant")
            case .cafe:
                String(localized: "Cafe")
            case .park:
                String(localized: "Park")
            case .bench:
                String(localized: "Bench")
            case .club:
                String(localized: "Club")
            case .shoppingCentre:
                String(localized: "Shopping centre")
            case .store:
                String(localized: "Store")
            case .hotel:
                String(localized: "Hotel")
            case .pharmacy:
                String(localized: "Pharmacy")
            case .monument:
                String(localized: "Monument")
            }
        }
    }
    
    var id: String
    let name: String
    let description: String?
    let city: String?
    let kind: Kind
    let point: (Double, Double)
    let owner: String
    
    var dictionary: [String: Any] {
        [
            "id": id,
            "name": name,
            "description": description ?? "",
            "city": city ?? "",
            "kind": kind.rawValue,
            "latitude": point.0,
            "longitude": point.1,
            "owner": owner
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let kindRawValue = dictionary["kind"] as? String,
            let kind = Kind(rawValue: kindRawValue),
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let owner = dictionary["owner"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.description = dictionary["description"] as? String
        self.city = dictionary["city"] as? String
        self.kind = kind
        self.point = (latitude, longitude)
        self.owner = owner
    }
    
    init(
        id: String, name: String,
        description: String?,
        city: String?, kind: Kind,
        point: (Double, Double),
        owner: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.city = city
        self.kind = kind
        self.point = point
        self.owner = owner
    }
}
