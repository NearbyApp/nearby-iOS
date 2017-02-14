//
//  LandingViewController.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-01-24.
//
//

import UIKit
import GoogleMaps

class LandingViewController: UIViewController
{
    @IBOutlet var mapContainer: UIView!
    @IBOutlet var topHeaderContainer: UIView!
    
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topHeaderContainer.frame = CGRect(x:0, y:20, width: screenSize.width, height: 50)
        topHeaderContainer.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        
        self.displayGoogleMaps()
    }
    
    // Functions
    func displayGoogleMaps() {
        var mapView:GMSMapView?
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), camera: GMSCameraPosition.camera(withLatitude: 45.4948769, longitude: -73.5632654, zoom: 12.0))
        
        self.mapContainer.addSubview(mapView!)
    }
}
