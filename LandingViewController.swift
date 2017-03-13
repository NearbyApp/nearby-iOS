//
//  LandingViewController.swift
//  nearbyapp
//
//  Created by Samuel Ryc on 2017-01-24.
//
//

import UIKit
import GoogleMaps
import FacebookCore

class LandingViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, GMUClusterManagerDelegate
{
    @IBOutlet var topHeaderContainer: UIView!
    @IBOutlet var MapContainer: UIView!
    
    private var mapView: GMSMapView! = nil;
    private var clusterManager: GMUClusterManager!
    private var locationManager = CLLocationManager()
    private var zoom:Float = 12.0
    private var spottedView: SpottedView!
    private var newSpottedView: NewSpottedView!
    
    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        self.topHeaderContainer.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: 50)
        self.topHeaderContainer.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        
        self.topHeaderContainer.addSubview(self.createLabelButton(text: "+", cgrect: CGRect(x: screenSize.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
        
        self.displayGoogleMaps()
    }
    
    func displayGoogleMaps() {
        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), camera: GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: self.zoom))
        self.mapView.delegate = self
        self.mapView.settings.compassButton = true
        self.mapView.settings.myLocationButton = true
        self.mapView.isMyLocationEnabled = true
        self.MapContainer.addSubview(mapView)
        
        // Adding center on map button
        self.mapView.addSubview(self.createButton(imgName: "ic_qu_direction_mylocation.png", cgrect: CGRect(x: screenSize.width-40, y: 10, width:30, height:30), backgroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.centerMapAction(_:))))
        }
    
    func fetchMarkersInArea(minLat: Float, maxLat: Float, minLong: Float, maxLong: Float) {
        let arrayMarkers = API().fetchMarkersInArea(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, minLat: minLat, maxLat: maxLat, minLong: minLong, maxLong: maxLong)
        
        // Displaying Markers on the map
        for markerModel in arrayMarkers {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: markerModel.latitude, longitude: markerModel.longitude)
            marker.title = markerModel.id
            marker.map = self.mapView
        }
    }
    
    // Google map on move function
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let minLat = min(mapView.projection.visibleRegion().farLeft.latitude, mapView.projection.visibleRegion().farRight.latitude, mapView.projection.visibleRegion().nearLeft.latitude, mapView.projection.visibleRegion().farRight.latitude)
        let maxLat = max(mapView.projection.visibleRegion().farLeft.latitude, mapView.projection.visibleRegion().farRight.latitude, mapView.projection.visibleRegion().nearLeft.latitude, mapView.projection.visibleRegion().farRight.latitude)
        let minLong = min(mapView.projection.visibleRegion().farLeft.longitude, mapView.projection.visibleRegion().farRight.longitude, mapView.projection.visibleRegion().nearLeft.longitude, mapView.projection.visibleRegion().farRight.longitude)
        let maxLong = max(mapView.projection.visibleRegion().farLeft.longitude, mapView.projection.visibleRegion().farRight.longitude, mapView.projection.visibleRegion().nearLeft.longitude, mapView.projection.visibleRegion().farRight.longitude)
        
        self.fetchMarkersInArea(minLat: Float(minLat), maxLat: Float(maxLat), minLong: Float(minLong), maxLong: Float(maxLong))
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        // Creates the view to display spotted information
        self.spottedView = SpottedView(frame: CGRect.zero)
        self.spottedView.fetchSpotted(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, spottedId: marker.title!)
        self.mapView.addSubview(self.spottedView)
        
        self.topHeaderContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        // Creates the back button to return to the map when clicked
        self.topHeaderContainer.addSubview(self.createLabelButton(text: "Back", cgrect: CGRect(x: -20, y: 0, width: 100, height: 40), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.backToMap(_:))))
        
        return self.spottedView
    }
    
    // Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
    }
    
    // Actions
    @IBAction func sendSpotted(_ sender: Any) {
        self.newSpottedView.removeFromSuperview()
        self.topHeaderContainer.subviews.forEach({ $0.removeFromSuperview() })
        self.topHeaderContainer.addSubview(self.createLabelButton(text: "+", cgrect: CGRect(x: screenSize.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
        
        let message = self.newSpottedView.getSpottedMessage()
        
        let result = API().publishSpotted(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, anonymity: true, longitude: Float((self.locationManager.location?.coordinate.longitude)!), latitude: Float((self.locationManager.location?.coordinate.latitude)!), message: message)
    }
    
    @IBAction func centerMapAction(_ sender: Any) {
        self.mapView.animate(to: GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude:(self.locationManager.location?.coordinate.longitude)!, zoom:self.zoom))
    }
    
    @IBAction func backToMap(_ sender: Any) {
        (sender as AnyObject).removeFromSuperview()
        if (self.spottedView != nil) {
            self.spottedView.removeFromSuperview()
        }
        
        if (self.newSpottedView != nil) {
            self.newSpottedView.removeFromSuperview()
        }
        
        self.topHeaderContainer.addSubview(self.createLabelButton(text: "+", cgrect: CGRect(x: screenSize.width-25, y: 5, width: 20, height: 30), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.newSpotted(_:))))
    }
    
    @IBAction func newSpotted(_ sender: Any) {
        (sender as AnyObject).removeFromSuperview()
        self.topHeaderContainer.addSubview(self.createLabelButton(text: "Back", cgrect: CGRect(x: -20, y: 0, width: 100, height: 40), color: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.backToMap(_:))))
        
        self.newSpottedView = NewSpottedView(frame: CGRect.zero)
        self.mapView.addSubview(self.newSpottedView)
        
        self.topHeaderContainer.addSubview(self.createLabelButton(text: "Send", cgrect: CGRect(x: screenSize.width-60, y: 5, width: 50, height: 30), color: UIColor.black, selector: #selector(LandingViewController.sendSpotted(_:))))
    }
    
    // Function that creates a Button
    private func createButton(imgName: String, cgrect: CGRect, backgroundColor: UIColor, selector:Selector) -> UIButton {
        let button = UIButton(type: UIButtonType.infoLight) as UIButton
        button.frame = cgrect
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.setImage(UIImage(named: imgName) as UIImage?, for: .normal)
        button.addTarget(self, action: selector, for:.touchUpInside)
        
        return button
    }
    
    // Function that creates a LabelButton
    private func createLabelButton(text: String, cgrect: CGRect, color: UIColor, selector:Selector) -> UIButton {
        let label = UIButton(type: UIButtonType.custom) as UIButton
        label.frame = cgrect
        label.tintColor = color
        label.setTitle(text, for: .normal)
        label.addTarget(self, action: selector, for:.touchUpInside)
        
        return label
    }
}
