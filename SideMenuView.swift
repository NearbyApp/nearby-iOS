//
//  SpottedView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-04.
//

import Foundation
import UIKit

class SideMenuView: UIView
{    
    private let all_my_spotteds_views = AllMySpottedsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        self.addSubview(createLabelButton(text: "My Spotteds", cgrect: CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width/2, height: 30), color: .black, selector:#selector(SideMenuView.mySpotteds(_:))))
        //self.addSubview(createLabelButton(text: "Logout", cgrect: CGRect(x: 0, y: 40, width: screenSize.width/2, height: 30), color: .black, selector:#selector(SideMenuView.logout(_:))))
    }
    
    private func createLabelButton(text: String, cgrect: CGRect, color: UIColor, selector: Selector) -> UIButton
    {
        let label = UIButton(type: UIButtonType.custom) as UIButton
        label.frame = cgrect
        label.tintColor = color
        label.setTitle(text, for: .normal)
        label.setTitleColor(color, for: .normal)
        label.addTarget(self, action: selector, for:.touchUpInside)
        return label
    }
    
    public func getAllMySpottedView() -> AllMySpottedsView
    {
        return all_my_spotteds_views
    }
    
    @IBAction func mySpotteds(_ sender: Any)
    {
        //self.removeFromSuperview()
        self.addSubview(all_my_spotteds_views)
        all_my_spotteds_views.fetchMySpotteds()
    }
    
    /*@IBAction func logout(_ sender: Any)
    {
        LandingViewController().clearFacebookInfo()
    }*/
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
