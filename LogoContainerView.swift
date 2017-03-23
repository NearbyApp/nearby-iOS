//
//  LoginView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-22.
//
//

import Foundation
import UIKit

class LogoContainerView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        
        // Adding the logo image to the container
        let logo_image = UIImageView(image: UIImage(named: "logo"))
        logo_image.frame = CGRect(x: (UIScreen.main.bounds.width/2)-100, y: 80, width: 200, height: 240)
        self.addSubview(logo_image)
        
        // Adding the Nearby label to the container
        let label = UILabel()
        label.frame = CGRect(x: (UIScreen.main.bounds.width/2)-42, y: 360, width: 140, height: 40)
        label.textColor = .white
        label.font = label.font.withSize(30)
        label.text = "Nearby"
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
