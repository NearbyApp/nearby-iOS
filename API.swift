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
    private var facebookId: String!
    private var accessToken: String!
    
    public func facebookAuthenticate(token accessToken: String, id facebookId: String) -> Bool
    {
        var success = true
        self.accessToken = accessToken
        self.facebookId = facebookId
        
        // Building request
        var request = self.buildRequest(url: "/v1/login", requestParams: "", method: "POST")
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
    
    public func fetchMarkersInArea(token accessToken: String, id facebookId: String, minLat: Float, maxLat: Float, minLong: Float, maxLong: Float) -> Array<Marker>
    {
        var arrayMarkers = Array<Marker>()
        
        self.accessToken = accessToken
        self.facebookId = facebookId
        
        // Building request
        let request = self.buildRequest(url: "/v1/spotteds", requestParams: "?minLat=" + String(minLat) + "&maxLat=" + String(maxLat) + "&minLong=" + String(minLong) + "&maxLong=" + String(maxLong) + "&locationOnly=" + "true", method: "GET")
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        var myData = Data()
        
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
    
    public func fetchSpottedById(spottedId: String) -> Spotted
    {
        let defaults = UserDefaults.standard
        let arr = defaults.string(forKey: defaultsKeys.access_token)?.components(separatedBy: ",")
        self.accessToken = arr?[0]
        self.facebookId = arr?[1]
        
        // Building request
        let request = self.buildRequest(url: "/v1/spotted/", requestParams: spottedId, method: "GET")
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        var myData = Data()
        
        // Calling API
        let task = session.dataTask(with: request) {(data, response, error) in
            myData = data!
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        var json = JSON(data: myData)
        var fullName: String = ""
        var pictureURL: String = ""
        var profilePictureURL: String = ""
        
        if (json["fullName"] == nil) {
            fullName = "Anonymous"
        } else {
            fullName = String(describing: json["fullName"])
        }
        
        if (json["pictureURL"] != nil) {
            pictureURL = String(describing: json["pictureURL"])
        }
        
        if (json["profilePictureURL"] != nil) {
            profilePictureURL = String(describing: json["profilePictureURL"])
        }
    
        return Spotted(id: String(describing: json["_id"]), fullName: fullName, pictureURL: pictureURL, profilePictureURL: profilePictureURL, creationDate: String(describing: json["creationDate"]), message: String(describing: json["message"]))
    }
    
    public func fetchImageFromURL(url: String) -> UIImage
    {
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0);
        
        var image:UIImage? = nil
        
        let downloadPicTask = session.dataTask(with: request) { (data, response, error) in
            
            if (response as? HTTPURLResponse) != nil {
                if let imageData = data {
                    image = UIImage(data: imageData)
                }
            }
            
            semaphore.signal()
        }
        
        downloadPicTask.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return image!
    }
    
    public func publishSpotted(token accessToken: String, id facebookId: String, anonymity: Bool, longitude: Float, latitude: Float, message: String) -> Bool
    {
        self.accessToken = accessToken
        self.facebookId = facebookId
        
        var request = self.buildRequest(url: "/v1/spotted", requestParams: "", method: "POST")
        let getMethodData = "anonymity=" + String(anonymity) + "&longitude=" + String(longitude) + "&latitude=" + String(latitude) + "&message=" + message
        request.httpBody = getMethodData.data(using: .utf8)
        let session = URLSession.shared
        
        let newSpottedTask = session.dataTask(with: request) { (data, response, error) in
        }
        
        newSpottedTask.resume()
        
        return true
    }
    
    public func getMySpotted() -> Array<SpottedBasic>
    {
        var array_spotted = Array<SpottedBasic>()
        
        let defaults = UserDefaults.standard
        let arr = defaults.string(forKey: defaultsKeys.access_token)?.components(separatedBy: ",")
        self.accessToken = arr?[0]
        self.facebookId = arr?[1]
        
        let request = self.buildRequest(url: "/v1/spotteds/me", requestParams: "", method: "GET")
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        
        var myData = Data()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            myData = data!
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait(timeout: DispatchTime.distantFuture)
        
        for (_, subJson):(String, JSON) in JSON(data: myData) {
            
            if (subJson["_id"].stringValue != "") {
                array_spotted.append(SpottedBasic(id: subJson["_id"].stringValue, message: subJson["message"].stringValue))
            }
            
        }
        
        return array_spotted
    }
    
    private func buildRequest(url: String, requestParams: String, method: String) -> URLRequest
    {
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
