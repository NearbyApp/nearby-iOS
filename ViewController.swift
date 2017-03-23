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

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.backgroundColor = .white
        self.view.addSubview(LogoContainerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500)))
        
        // Facebook authentication button creation
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Facebook", for: .normal)
        button.frame = CGRect(x: 20, y: UIScreen.main.bounds.height-140, width: UIScreen.main.bounds.width-40, height: 50)
        button.backgroundColor = UIColor(red: 58/255, green: 87/255, blue: 155/255, alpha: 1)
        button.addTarget(self, action: #selector(self.facebookConnectAction(_:)), for:.touchUpInside)
        self.view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if AccessToken.current != nil {
            //goToLandingPage()
        }
    }
    
    // -------------- Custom functions definition -------------- //
    private func authenticateUserByFacebook(accessToken: AccessToken)
    {
        if (API().facebookAuthenticate(token: accessToken.authenticationToken, id: accessToken.userId!)) {
            goToLandingPage()
        } else {
            alert(message: "Something went wrong with ...", title: "Error")
        }
    }
    
    private func goToLandingPage()
    {
        let landing_view_controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
        self.navigationController?.pushViewController(landing_view_controller, animated: true)
        self.present(landing_view_controller, animated: true, completion: nil)
    }
    
    private func alert(message: String, title: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // -------------- Action -------------- //
    @IBAction func facebookConnectAction(_ sender: Any)
    {
        LoginManager().logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.alert(message: "FACEBOOK LOGIN FAILED: \(error)", title: "FAIL")
            case .cancelled:
                self.alert(message: "User cancelled login.", title: "CANCELLED")
            case .success( _, _, let accessToken):
                self.authenticateUserByFacebook(accessToken: accessToken)
            }
        }
    }
}

