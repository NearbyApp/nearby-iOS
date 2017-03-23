//
//  LandingViewController.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-01-24.
//
//

import UIKit
import GoogleMaps
import FacebookLogin
import FacebookCore

class LandingViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate
{    
    private var map_view: GMSMapView! = nil
    private var location_manager = CLLocationManager()
    private var zoom: Float = 12.0
    private var spotted_view: SpottedView!
    private var create_spotted_view = CreateSpottedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    private var side_menu_view = SideMenuView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height))
    private var top_header_container_view: UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.backgroundColor = .white
        
        top_header_container_view = TopHeaderMenuView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 40))
        self.view.addSubview(top_header_container_view)
        
        if CLLocationManager.locationServicesEnabled() {
            location_manager.requestAlwaysAuthorization()
            location_manager.requestWhenInUseAuthorization()
            location_manager.delegate = self
            location_manager.desiredAccuracy = kCLLocationAccuracyBest
            location_manager.startUpdatingLocation()
        }
        
        top_header_container_view.addSubview(createLabelButton(text: "+", cgrect: CGRect(x: UIScreen.main.bounds.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
        top_header_container_view.addSubview(createLabelButton(text: "Menu", cgrect: CGRect(x: 5, y: 5, width: 60, height: 30), color: .white, selector: #selector(LandingViewController.menu(_:))))
        
        displayGoogleMaps()
    }
    
    // -------------- Custom functions definition -------------- //
    private func displayGoogleMaps()
    {
        map_view = GMSMapView.map(withFrame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), camera: GMSCameraPosition.camera(withLatitude: (location_manager.location?.coordinate.latitude)!, longitude: (location_manager.location?.coordinate.longitude)!, zoom: self.zoom))
        map_view.delegate = self
        map_view.isMyLocationEnabled = true
        self.view.addSubview(map_view)
        
        map_view.addSubview(createButton(imgName: "ic_qu_direction_mylocation.png", cgrect: CGRect(x: UIScreen.main.bounds.width-40, y: 10, width:30, height:30), backgroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.centerMapAction(_:))))
    }
    
    private func fetchMarkersInArea(minLat: Float, maxLat: Float, minLong: Float, maxLong: Float)
    {
        let arrayMarkers = API().fetchMarkersInArea(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, minLat: minLat, maxLat: maxLat, minLong: minLong, maxLong: maxLong)
        
        for markerModel in arrayMarkers {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: markerModel.latitude, longitude: markerModel.longitude)
            marker.userData = markerModel.id
            marker.map = map_view
        }
    }
    
    /*public func clearFacebookInfo()
    {
        LoginManager().logOut()
        self.navigationController?.popToViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController"), animated: true)
    }*/
    
    private func createButton(imgName: String, cgrect: CGRect, backgroundColor: UIColor, selector:Selector) -> UIButton
    {
        let button = UIButton(type: UIButtonType.infoLight) as UIButton
        button.frame = cgrect
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.setImage(UIImage(named: imgName) as UIImage?, for: .normal)
        button.addTarget(self, action: selector, for:.touchUpInside)
        return button
    }
    
    private func createLabelButton(text: String, cgrect: CGRect, color: UIColor, selector:Selector) -> UIButton
    {
        let label = UIButton(type: UIButtonType.custom) as UIButton
        label.frame = cgrect
        label.tintColor = color
        label.setTitle(text, for: .normal)
        label.addTarget(self, action: selector, for:.touchUpInside)
        return label
    }
    
    private func alert(message: String, title: String = "")
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // -------------- function redifinition -------------- //
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        let min_lat = min(map_view.projection.visibleRegion().farLeft.latitude, map_view.projection.visibleRegion().farRight.latitude, map_view.projection.visibleRegion().nearLeft.latitude, map_view.projection.visibleRegion().farRight.latitude)
        let max_lat = max(map_view.projection.visibleRegion().farLeft.latitude, map_view.projection.visibleRegion().farRight.latitude, map_view.projection.visibleRegion().nearLeft.latitude, map_view.projection.visibleRegion().farRight.latitude)
        let min_long = min(map_view.projection.visibleRegion().farLeft.longitude, map_view.projection.visibleRegion().farRight.longitude, map_view.projection.visibleRegion().nearLeft.longitude, map_view.projection.visibleRegion().farRight.longitude)
        let max_long = max(map_view.projection.visibleRegion().farLeft.longitude, map_view.projection.visibleRegion().farRight.longitude, map_view.projection.visibleRegion().nearLeft.longitude, map_view.projection.visibleRegion().farRight.longitude)
        
        self.fetchMarkersInArea(minLat: Float(min_lat), maxLat: Float(max_lat), minLong: Float(min_long), maxLong: Float(max_long))
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        spotted_view = SpottedView(frame: CGRect(x: 0, y: 59, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        spotted_view.fetchSpotted(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, spottedId: marker.userData! as! String)
        self.view.addSubview(spotted_view)
        
        top_header_container_view.subviews.forEach({ $0.removeFromSuperview() })
    
        top_header_container_view.addSubview(createLabelButton(text: "Back", cgrect: CGRect(x: -20, y: 0, width: 100, height: 40), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.backToMap(_:))))
        
        return nil // we don't return any view since we're displaying our own on top of the mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse {
            location_manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        location_manager.stopUpdatingLocation()
    }
    
    // -------------- Actions -------------- //
    @IBAction func sendAnonymousSpotted(_ sender: Any)
    {
        create_spotted_view.removeFromSuperview()
        top_header_container_view.subviews.forEach({ $0.removeFromSuperview() })
        top_header_container_view.addSubview(createLabelButton(text: "+", cgrect: CGRect(x: UIScreen.main.bounds.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
        
        let message = create_spotted_view.getSpottedMessage()
        let result = API().publishSpotted(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, anonymity: true, longitude: Float((location_manager.location?.coordinate.longitude)!), latitude: Float((location_manager.location?.coordinate.latitude)!), message: message)
        
        if (result == true) {
            alert(message: "Your message was successfully sent!", title: "Success")
        } else {
            alert(message: "Your message was not sent! Something went wrong!", title: "Error")
        }
    }
    
    @IBAction func centerMapAction(_ sender: Any)
    {
        map_view.animate(to: GMSCameraPosition.camera(withLatitude: (location_manager.location?.coordinate.latitude)!, longitude:(location_manager.location?.coordinate.longitude)!, zoom:self.zoom))
    }
    
    @IBAction func backToMap(_ sender: Any) {
        top_header_container_view.subviews.forEach({ $0.removeFromSuperview() })
        
        side_menu_view.removeFromSuperview()
        
        if (spotted_view != nil) {
            spotted_view.removeFromSuperview()
        }
        
        side_menu_view.getAllMySpottedView().removeFromSuperview()
        
        create_spotted_view.removeFromSuperview()
        
        top_header_container_view.addSubview(createLabelButton(text: "Menu", cgrect: CGRect(x: 5, y: 5, width: 60, height: 30), color: .white, selector: #selector(LandingViewController.menu(_:))))
        top_header_container_view.addSubview(createLabelButton(text: "+", cgrect: CGRect(x: UIScreen.main.bounds.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
    }
    
    @IBAction func sendSpotted(_ sender: Any)
    {
        create_spotted_view.removeFromSuperview()
        top_header_container_view.subviews.forEach({ $0.removeFromSuperview() })
        top_header_container_view.addSubview(createLabelButton(text: "+", cgrect: CGRect(x: UIScreen.main.bounds.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
        
        let message = create_spotted_view.getSpottedMessage()
        let result = API().publishSpotted(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, anonymity: false, longitude: Float((location_manager.location?.coordinate.longitude)!), latitude: Float((location_manager.location?.coordinate.latitude)!), message: message)
        
        if (result == true) {
            alert(message: "Your message was successfully sent!", title: "Success")
        } else {
            alert(message: "Your message was not sent! Something went wrong!", title: "Error")
        }
    }
    
    @IBAction func newSpotted(_ sender: Any)
    {
        top_header_container_view.subviews.forEach({ $0.removeFromSuperview() })
        top_header_container_view.addSubview(createLabelButton(text: "Back", cgrect: CGRect(x: -20, y: 0, width: 100, height: 40), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.backToMap(_:))))
        map_view.addSubview(create_spotted_view)
        top_header_container_view.addSubview(createLabelButton(text: "Send", cgrect: CGRect(x: UIScreen.main.bounds.width-60, y: 5, width: 50, height: 30), color: UIColor.black, selector: #selector(LandingViewController.sendSpotted(_:))))
        top_header_container_view.addSubview(createLabelButton(text: "Send Anonymous", cgrect: CGRect(x: (UIScreen.main.bounds.width/2)-80, y: 5, width: 160, height: 30), color: UIColor.black, selector: #selector(LandingViewController.sendAnonymousSpotted(_:))))
    }
    
    @IBAction func menu(_ sender: Any)
    {
        top_header_container_view.subviews.forEach({ $0.removeFromSuperview() })
        top_header_container_view.addSubview(createLabelButton(text: "Back to map", cgrect: CGRect(x: 5, y: 5, width: 130, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.backToMap(_:))))
        map_view.addSubview(side_menu_view)
    }
}
