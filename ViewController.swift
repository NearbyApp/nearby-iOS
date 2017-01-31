//
//  ViewController.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-01-24.
//
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var facebookConnect: UIButton!
    @IBOutlet var googleConnect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        
        // Set the background to the appropriate color
        logoContainer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 500)
        logoContainer.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        
        facebookConnect.backgroundColor = UIColor(red: 58/255, green: 87/255, blue: 155/255, alpha: 1)
        
        googleConnect.backgroundColor = UIColor(red: 220/255, green: 74/255, blue: 56/255, alpha: 1)

    }
    
    //MARK: Actions
    @IBAction func facebookConnectAction(_ sender: Any) {
        
    }
    
    @IBAction func googleConnectAction(_ sender: Any) {
        
    }

}

