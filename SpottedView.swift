//
//  SpottedView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-04.
//
//

import Foundation
import UIKit

class SpottedView: UIView
{
    private let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    public func fetchSpotted(token accessToken: String, id facebookId: String, spottedId: String)
    {
        let spotted:Spotted! = API().fetchSpottedById(token: accessToken, id: facebookId, spottedId: spottedId)
        
        // Spotted user image
        if (spotted.profilePictureURL != "") {
            self.addSubview(createImageByURL(url: spotted.profilePictureURL, cgrect: CGRect(x: 10, y: 10, width: 40, height: 40)))
        } else {
            self.addSubview(createImage(path: "question-mark.png", cgrect: CGRect(x: 10, y: 10, width: 40, height: 40)))
        }
        
        // Message
        self.addSubview(createLabel(cgrect: CGRect(x: 10, y: 50, width: screenSize.width-10, height: 40), text: spotted.message))
        
        // FullName
        self.addSubview(createLabel(cgrect: CGRect(x: 60, y: 10, width: screenSize.width-10, height: 40), text: spotted.fullName))
        
        // Spotted image
        if (spotted.pictureURL != "") {
            self.addSubview(createImageByURL(url: spotted.pictureURL, cgrect: CGRect(x: 0, y: 90, width: screenSize.width, height: 520)))
        }
    }

    private func createLabel(cgrect: CGRect, text: String) -> UILabel
    {
        let label = UILabel() as UILabel
        label.frame = cgrect
        label.text = text
        return label
    }
    
    private func createImageByURL(url: String, cgrect: CGRect) -> UIView
    {
        let imageView = UIImageView(frame: cgrect)
        imageView.image = API().fetchImageFromURL(url: url)
        return imageView
    }
    
    private func createImage(path: String, cgrect: CGRect) -> UIView
    {
        let imageView = UIImageView(frame: cgrect)
        imageView.image = UIImage(named: path) as UIImage?
        return imageView
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
