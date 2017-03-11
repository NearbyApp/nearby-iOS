//
//  SpottedView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-04.
//
//

import Foundation
import UIKit
import PureLayout

class SpottedView: UIView {
    var shouldSetupConstraints = true
    var spottedView: UIImageView!
    let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        spottedView = UIImageView(frame: CGRect.zero)
        spottedView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        spottedView.backgroundColor = UIColor.white
        self.addSubview(spottedView)
    }
    
    public func fetchSpotted(token accessToken:String, id facebookId:String, spottedId: String) {
        let spotted:Spotted! = API().fetchSpottedById(token: accessToken, id: facebookId, spottedId: spottedId)
        
        // Spotted user image
        if (spotted.profilePictureURL != "") {
            self.addSubview(self.createImageByURL(url: spotted.profilePictureURL, cgrect: CGRect(x: 10, y: 10, width: 40, height: 40)))
        } else {
            self.addSubview(self.createImage(path: "question-mark.png", cgrect: CGRect(x: 10, y: 10, width: 40, height: 40)))
        }
        
        // Message
        self.addSubview(self.createLabel(cgrect: CGRect(x: 10, y: 50, width: screenSize.width-10, height: 40), text: spotted.message))
        
        // FullName
        self.addSubview(self.createLabel(cgrect: CGRect(x: 60, y: 10, width: screenSize.width-10, height: 40), text: spotted.fullName))
        
        // Spotted image
        if (spotted.pictureURL != "") {
            self.addSubview(self.createImageByURL(url: spotted.pictureURL, cgrect: CGRect(x: 0, y: 90, width: screenSize.width, height: 520)))
        }
    }
    
    // Function that creates a Label
    private func createLabel(cgrect: CGRect, text: String) -> UILabel {
        let label = UILabel() as UILabel
        label.frame = cgrect
        label.text = text
        return label
    }
    
    // Function that creates a ImageView based on the given URL
    private func createImageByURL(url: String, cgrect: CGRect) -> UIView {
        let imageView = UIImageView(frame: cgrect)
        imageView.image = API().fetchImageFromURL(url: url)
        return imageView
    }
    
    private func createImage(path: String, cgrect: CGRect) -> UIView {
        let imageView = UIImageView(frame: cgrect)
        imageView.image = UIImage(named: path) as UIImage?
        return imageView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
