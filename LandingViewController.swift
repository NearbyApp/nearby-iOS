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
    
    let screenSize = UIScreen.main.bounds
    let buttonBack = UIButton(type: UIButtonType.infoLight) as UIButton

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        topHeaderContainer.frame = CGRect(x:0, y:20, width: screenSize.width, height: 50)
        topHeaderContainer.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1)
        
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
        
        // Adding + button
        self.mapView.addSubview(self.createButton(imgName: "zoom.png", cgrect: CGRect(x: screenSize.width-40, y: 60, width:30, height:30), backgroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.zoomInAction(_:))))
        
        // Adding - button
        self.mapView.addSubview(self.createButton(imgName: "minus.png", cgrect: CGRect(x: screenSize.width-40, y: 100, width:30, height:30), backgroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), selector: #selector(LandingViewController.zoomOutAction(_:))))
    }
    
    func fetchMarkersInArea(minLat: Float, maxLat: Float, minLong: Float, maxLong: Float) {
        let arrayMarkers = API().fetchMarkersInArea(minLat: minLat, maxLat: maxLat, minLong: minLong, maxLong: maxLong)
        
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
        self.spottedView.fetchSpotted(spottedId: marker.title!)
        self.mapView.addSubview(self.spottedView)
        
        // Creates the back button to return to the map when clicked
        let imageBack = UIImage(named: "back.png") as UIImage?
        self.buttonBack.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        self.buttonBack.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.buttonBack.setImage(imageBack, for: .normal)
        self.buttonBack.addTarget(self, action: #selector(LandingViewController.backToMap(_:)), for:.touchUpInside)
        self.topHeaderContainer.addSubview(self.buttonBack)
        
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
    @IBAction func centerMapAction(_ sender: Any) {
        self.mapView.animate(to: GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude:(self.locationManager.location?.coordinate.longitude)!, zoom:self.zoom))
    }
    
    @IBAction func zoomInAction(_ sender: Any) {
        self.zoom = self.zoom + 1.0
        self.mapView.animate(to: GMSCameraPosition.camera(withLatitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude, zoom:self.zoom))
    }
    
    @IBAction func zoomOutAction(_ sender: Any) {
        self.zoom = self.zoom - 1.0
        self.mapView.animate(to: GMSCameraPosition.camera(withLatitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude, zoom:self.zoom))
    }
    
    @IBAction func backToMap(_ sender: Any) {
        self.buttonBack.removeFromSuperview()
        self.spottedView.removeFromSuperview()
    }
    
    // Function that creates a Button
    private func createButton(imgName: String, cgrect: CGRect, backgroundColor: UIColor, selector:Selector) -> UIButton {
        let button = UIButton(type: UIButtonType.infoLight) as UIButton
        button.frame = cgrect
        button.backgroundColor = backgroundColor
        button.setImage(UIImage(named: imgName) as UIImage?, for: .normal)
        button.addTarget(self, action: selector, for:.touchUpInside)
        
        return button
    }
}
