//
//  SpottedView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-04.
//

import Foundation
import UIKit

class CreateSpottedView: UIView, UITextFieldDelegate
{
    private var text_field: UITextField? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        text_field = UITextField(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width-10, height: 30))
        text_field?.placeholder = "What did you spot?"
        text_field?.autocorrectionType = UITextAutocorrectionType.no
        text_field?.keyboardType = UIKeyboardType.default
        text_field?.returnKeyType = UIReturnKeyType.done
        text_field?.clearButtonMode = UITextFieldViewMode.whileEditing;
        text_field?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        text_field?.delegate = self
        text_field?.becomeFirstResponder()
        text_field?.clearsOnBeginEditing = true
        
        self.addSubview(text_field!)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getSpottedMessage() -> String
    {
        return text_field!.text!
    }
}
