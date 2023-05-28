//
//  PointManager.swift
//  RoadFeatures
//
//  Created by Alex Gav on 24.05.2023.
//

import Foundation

class PointManager {
    private let firebaseManager = FirebaseManager.shared
    static let shared = PointManager()
    private var points: [Point] = []
    
    private init() {
        getAllFromDatabase { (allPoints, error) in
            if let error = error {
                print("Failed to get points:", error)
            } else if let allPoints = allPoints {
                self.points = allPoints
            }
        }
    }
    
    
    func getAllFromDatabase(completion: @escaping ([Point]?, Error?) -> Void) {
        firebaseManager.getDocuments(collection: "points") { (documents, error) in
            if let error = error {
                completion(nil, error)
            } else if let documents = documents {
                let points = documents.compactMap { Point(dictionary: $0) }
                completion(points, nil)
            }
        }
    }
    
    func getAllFromDatabaseForCurrentUser(userID: String, completion: @escaping ([Point]?, Error?) -> Void) {
        firebaseManager.getDocuments(collection: "points") { (documents, error) in
            if let error = error {
                completion(nil, error)
            } else if let documents = documents {
                let points = documents.compactMap { Point(dictionary: $0) }
                let pointsForCurrentUser = points.filter { $0.owner == userID }
                completion(pointsForCurrentUser, nil)
            }
        }
    }
    
    func add(point: Point, completion: @escaping (Error?, String?) -> Void) {
        firebaseManager.addDocument(collection: "points", data: point.dictionary) { [self] (documentID, error) in
            if let error = error {
                completion(error, nil)
            } else if let documentID = documentID {
                var updatedPointData = point.dictionary
                updatedPointData["id"] = documentID
                firebaseManager.setNewId(documentID: documentID, data: updatedPointData)
                completion(nil, documentID)
            }
        }
    }
    
    func remove(point: Point, completion: @escaping (Error?) -> Void) {
        firebaseManager.removeDocument(collection: "points", documentID: point.id, completion: completion)
    }
    
    func getPointByID(id: String, completion: @escaping (Point?, Error?) -> Void) {
        firebaseManager.getDocumentById(id: id) { point in
            if let point = point {
                completion(point, nil)
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No point found with the given ID"]))
            }
        }
    }
    
}
