//
//  Marker.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-02-20.
//
//

import Foundation

struct Marker
{
    let id: String
    let latitude: Double
    let longitude: Double
    let type: String
    let creationDate: String
    
    init(id: String, latitude: Double, longitude: Double, type: String, creationDate: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
        self.creationDate = creationDate
    }
}
