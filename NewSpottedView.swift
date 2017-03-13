//
//  SpottedView.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-03-04.
//

import Foundation
import UIKit

class NewSpottedView: UIView, UITextFieldDelegate {
    var shouldSetupConstraints = true
    var newSpottedView: UIImageView!
    let screenSize = UIScreen.main.bounds
    var textField:UITextField? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        newSpottedView = UIImageView(frame: CGRect.zero)
        newSpottedView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        newSpottedView.backgroundColor = UIColor.white
        self.addSubview(newSpottedView)
        
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
        
        self.newSpottedView.addSubview(textField!)
    }
    
    public func getSpottedMessage() -> String {
        return textField!.text!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
