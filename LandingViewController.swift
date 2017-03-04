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
    
    let screenSize = UIScreen.main.bounds
    let apiService = API()

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
        
        // Adding center button
        let image = UIImage(named: "ic_qu_direction_mylocation.png") as UIImage?
        let button = UIButton(type: UIButtonType.infoLight) as UIButton
        button.frame = CGRect(x: screenSize.width-40, y: 10, width:30, height:30)
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(LandingViewController.CenterMapAction(_:)), for:.touchUpInside)
        self.mapView.addSubview(button)
        
        // Adding + and - buttons
        let imagePlus = UIImage(named: "zoom.png") as UIImage?
        let buttonPlus = UIButton(type: UIButtonType.infoLight) as UIButton
        buttonPlus.frame = CGRect(x: screenSize.width-40, y: 60, width:30, height:30)
        buttonPlus.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        buttonPlus.setImage(imagePlus, for: .normal)
        buttonPlus.addTarget(self, action: #selector(LandingViewController.ZoomInAction(_:)), for:.touchUpInside)
        self.mapView.addSubview(buttonPlus)
        
        let imageMinus = UIImage(named: "minus.png") as UIImage?
        let buttonMinus = UIButton(type: UIButtonType.infoLight) as UIButton
        buttonMinus.frame = CGRect(x: screenSize.width-40, y: 100, width:30, height:30)
        buttonMinus.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        buttonMinus.setImage(imageMinus, for: .normal)
        buttonMinus.addTarget(self, action: #selector(LandingViewController.ZoomOutAction(_:)), for:.touchUpInside)
        self.mapView.addSubview(buttonMinus)
    }
    
    func fetchAllSpotteds(minLat: Float, maxLat: Float, minLong: Float, maxLong: Float) {
        var arraySpotteds = Array<Spotted>()

        arraySpotteds = apiService.fetchSpotteds(token: (AccessToken.current?.authenticationToken)!, id: (AccessToken.current?.userId)!, minLat: minLat, maxLat: maxLat, minLong: minLong, maxLong: maxLong)
        
        for spotted in arraySpotteds {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: spotted.latitude, longitude: spotted.longitude)
            marker.title = "Spotted"
            marker.snippet = spotted.message
            marker.map = self.mapView
        }
    }
    
    // Google map on move function
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let minLat = min(mapView.projection.visibleRegion().farLeft.latitude, mapView.projection.visibleRegion().farRight.latitude, mapView.projection.visibleRegion().nearLeft.latitude, mapView.projection.visibleRegion().farRight.latitude)
        let maxLat = max(mapView.projection.visibleRegion().farLeft.latitude, mapView.projection.visibleRegion().farRight.latitude, mapView.projection.visibleRegion().nearLeft.latitude, mapView.projection.visibleRegion().farRight.latitude)
        let minLong = min(mapView.projection.visibleRegion().farLeft.longitude, mapView.projection.visibleRegion().farRight.longitude, mapView.projection.visibleRegion().nearLeft.longitude, mapView.projection.visibleRegion().farRight.longitude)
        let maxLong = max(mapView.projection.visibleRegion().farLeft.longitude, mapView.projection.visibleRegion().farRight.longitude, mapView.projection.visibleRegion().nearLeft.longitude, mapView.projection.visibleRegion().farRight.longitude)
        self.fetchAllSpotteds(minLat: Float(minLat), maxLat: Float(maxLat), minLong: Float(minLong), maxLong: Float(maxLong))
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
    @IBAction func CenterMapAction(_ sender: Any) {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude:(self.locationManager.location?.coordinate.longitude)!, zoom:self.zoom)
        self.mapView.animate(to: camera)
    }
    
    @IBAction func ZoomInAction(_ sender: Any) {
        self.zoom = self.zoom + 1.0
        let camera = GMSCameraPosition.camera(withLatitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude, zoom:self.zoom)
        self.mapView.animate(to: camera)
    }
    
    @IBAction func ZoomOutAction(_ sender: Any) {
        self.zoom = self.zoom - 1.0
        let camera = GMSCameraPosition.camera(withLatitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude, zoom:self.zoom)
        self.mapView.animate(to: camera)
    }
}
