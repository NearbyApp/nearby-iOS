//
//  TopHeaderMenuView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-22.
//
//

import Foundation
import UIKit

class TopHeaderMenuView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
