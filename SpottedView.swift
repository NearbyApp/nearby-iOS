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
    
    public func fetchSpotted(spottedId: String) {
        API().fetchSpottedById(spottedId: spottedId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
