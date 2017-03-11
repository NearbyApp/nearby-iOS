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
    let fullName: String
    let pictureURL: String
    let creationDate: String
    let profilePictureURL: String
    let message: String
    
    init(id: String, fullName: String, pictureURL: String, profilePictureURL: String, creationDate: String, message: String) {
        self.id = id
        self.fullName = fullName
        self.pictureURL = pictureURL
        self.creationDate = creationDate
        self.profilePictureURL = profilePictureURL
        self.message = message
    }
}
