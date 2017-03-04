//
//  API.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-02-19.
//
//

import Foundation
import UIKit
import SwiftyJSON

class API
{
    func facebookAuthenticate(token accessToken:String, id facebookId:String) -> Bool {
        
        var success = true
        let loginString = String(format: "%@:%@", facebookId, accessToken)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // Building request
        var request = URLRequest(url: URL(string: "https://nbyapi.mo-bergeron.com/v1/login")!)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("Facebook", forHTTPHeaderField: "Service-Provider")
        let getMethodData = "facebookId=" + facebookId + "&token=" + accessToken
        request.httpBody = getMethodData.data(using: .utf8)
        let session = URLSession.shared
        
        // Calling API
        session.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print(error!)
                success = false
            }
        }.resume()
        return success
    }
    
    func fetchSpotteds(token accessToken:String, id facebookId: String, minLat: Float, maxLat: Float, minLong: Float, maxLong: Float) -> Array<Spotted> {
        var arraySpotteds = Array<Spotted>()
        let loginString = String(format: "%@:%@", facebookId, accessToken)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // Building request
        let getRequestParams = "?minLat=" + String(minLat) + "&maxLat=" + String(maxLat) + "&minLong=" + String(minLong) + "&maxLong=" + String(maxLong) + "&locationOnly=" + "false"
        var request = URLRequest(url: URL(string: "https://nbyapi.mo-bergeron.com/v1/spotteds" + getRequestParams)!)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("Facebook", forHTTPHeaderField: "Service-Provider")
        let session = URLSession.shared
        
        var myData = Data()
        let semaphore = DispatchSemaphore(value: 0);
        
        // Calling API
        let task = session.dataTask(with: request) {(data, response, error) in
            myData = data!
            semaphore.signal()
        }
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        for (_, subJson):(String, JSON) in JSON(data: myData) {
            if (subJson["_id"].stringValue != "") {
                let id = subJson["_id"].stringValue
                var userId = Int(subJson["userId"].stringValue)
                if (userId == nil) {
                    userId = 0
                }
                let anonymity = Bool(subJson["anonymity"].stringValue)
                let longitude = Double(subJson["location"]["coordinates"][0].stringValue)
                let latitude = Double(subJson["location"]["coordinates"][1].stringValue)
                let type = subJson["location"]["type"].stringValue
                let creationDate = subJson["creationDate"].stringValue
                let message = subJson["message"].stringValue
                
                var spotted: Spotted
                spotted = Spotted(id: id, userId: userId!, anonymity: anonymity!, latitude: latitude!, longitude: longitude!, type: type, creationDate: creationDate, message: message)
                arraySpotteds.append(spotted)

            }
        }
        return arraySpotteds
    }
}
