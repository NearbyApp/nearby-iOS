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
    private let screenSize = UIScreen.main.bounds
    private var textField:UITextField? = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        textField = UITextField(frame: CGRect(x: 10, y: 10, width: screenSize.width-10, height: 30))
        textField?.placeholder = "What did you spot?"
        textField?.autocorrectionType = UITextAutocorrectionType.no
        textField?.keyboardType = UIKeyboardType.default
        textField?.returnKeyType = UIReturnKeyType.done
        textField?.clearButtonMode = UITextFieldViewMode.whileEditing;
        textField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField?.delegate = self
        textField?.becomeFirstResponder()
        textField?.clearsOnBeginEditing = true
        
        self.addSubview(textField!)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getSpottedMessage() -> String
    {
        return textField!.text!
    }
}
