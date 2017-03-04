//
//  Spotted.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-01-31.
//
//

import Foundation

struct Spotted
{
    let id: String
    let userId: Int
    let anonymity: Bool
    let latitude: Double
    let longitude: Double
    let type: String
    let creationDate: String
    let message: String
    
    init(id: String, userId: Int, anonymity: Bool, latitude: Double, longitude: Double, type: String, creationDate: String, message: String) {
        self.id = id
        self.userId = userId
        self.anonymity = anonymity
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.creationDate = creationDate
        self.message = message
    }
}
