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
    override init(frame: CGRect)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
