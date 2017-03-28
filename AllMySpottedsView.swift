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
    private var y_position = 5
    private var spotted_view: SpottedView!
    
    override init(frame: CGRect)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.backgroundColor = UIColor.white
    }
    
    public func fetchMySpotteds() {
        var array_spotted = Array<SpottedBasic>()
        array_spotted = API().getMySpotted()
        
        for spotted in array_spotted {
            self.addSubview(createLabelButton(text: spotted.message, cgrect: CGRect(x: 5, y: y_position, width: Int(UIScreen.main.bounds.width-10), height: 40), spotted_id: spotted.id))
            y_position = y_position + 45
        }
    }
    
    private func createLabelButton(text: String, cgrect: CGRect, spotted_id: String) -> UIButton
    {
        let label = UIButton(type: UIButtonType.custom) as UIButton
        label.frame = cgrect
        label.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        label.setTitle(text, for: .normal)
        label.setTitle(spotted_id, for: .disabled) // This is really shady. It's the way I found to pass a variable via #selector... There's no solution anywhere...
        label.addTarget(self, action: #selector(getSpottedAction(spotted:)), for: .touchUpInside)
        return label
    }
    
    // -------------- Actions -------------- //
    func getSpottedAction(spotted: UIButton)
    {
        //self.removeFromSuperview()
        spotted_view = SpottedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        spotted_view.fetchSpotted(spottedId: spotted.title(for: .disabled)!)
        self.addSubview(spotted_view)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

