//
//  AllMySpotteds.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-20.
//
//

import Foundation
import UIKit

class AllMySpottedsView: UIView
{
    private var menu: UIImageView!
    private let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
