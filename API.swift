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
    private var accessToken:String = ""
    private var facebookId:String = ""
    
    public func facebookAuthenticate(token accessToken:String, id facebookId:String) -> Bool {
        self.accessToken = accessToken
        self.facebookId = facebookId
        var success = true
        
        // Building request
        var request = self.buildRequest(url: "/v1/login", requestParams: "", method: "POST")
        let getMethodData = "facebookId=" + self.facebookId + "&token=" + self.accessToken
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
    
    public func fetchMarkersInArea(minLat: Float, maxLat: Float, minLong: Float, maxLong: Float) -> Array<Marker> {
        var arrayMarkers = Array<Marker>()

        // Building request
        let request = self.buildRequest(url: "/v1/spotteds", requestParams: "?minLat=" + String(minLat) + "&maxLat=" + String(maxLat) + "&minLong=" + String(minLong) + "&maxLong=" + String(maxLong) + "&locationOnly=" + "true", method: "GET")
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
                arrayMarkers.append(Marker(id: subJson["_id"].stringValue, latitude: Double(subJson["location"]["coordinates"][1].stringValue)!, longitude: Double(subJson["location"]["coordinates"][0].stringValue)!, type: subJson["location"]["type"].stringValue, creationDate: subJson["creationDate"].stringValue))
            }
        }
        return arrayMarkers
    }
    
    public func fetchSpottedById(spottedId: String) {
        print(spottedId)
    }
    
    private func buildRequest(url: String, requestParams: String, method: String) -> URLRequest {
        let loginString = String(format: "%@:%@", self.facebookId, self.accessToken)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        var request = URLRequest(url: URL(string: "https://nbyapi.mo-bergeron.com" + url + requestParams)!)
        request.httpMethod = method
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("Facebook", forHTTPHeaderField: "Service-Provider")
        
        return request
    }
}
