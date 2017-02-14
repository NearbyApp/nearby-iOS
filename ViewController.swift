//
//  ViewController.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-01-24.
//
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

class ViewController: UIViewController
{
    @IBOutlet var logoContainer: UIView!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var facebookConnect: UIButton!
    @IBOutlet var googleConnect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        
        logoContainer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 500)
        logoContainer.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        facebookConnect.backgroundColor = UIColor(red: 58/255, green: 87/255, blue: 155/255, alpha: 1)
        googleConnect.backgroundColor = UIColor(red: 220/255, green: 74/255, blue: 56/255, alpha: 1)
        
        if let accessToken = AccessToken.current {
            // Verify login info and then redirect to landingView
        }
    }
    
    // Actions
    @IBAction func facebookConnectAction(_ sender: Any) {
        self.facebookSignIn()
    }
    
    @IBAction func googleConnectAction(_ sender: Any) {
        
    }
    
    @objc fileprivate func facebookSignIn() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.alert(message: "FACEBOOK LOGIN FAILED: \(error)", title: "FAIL")
            case .cancelled:
                self.alert(message: "User cancelled login.", title: "CANCELLED")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.goToLandingPage()
            }
        }
    }
    
    // Functions
    func goToLandingPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
        self.present(resultViewController, animated:true, completion:nil)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

