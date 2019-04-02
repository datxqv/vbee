//
//  SearchDeviceViewController.swift
//  VBee
//
//  Created by daicashigeru on 4/1/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class SearchDeviceViewController: BaseViewController {

    // MARK: - Variable and IBOutlet
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var lastedLocation: CLLocationCoordinate2D!
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 20.9974, longitude: 105.8266)
    var myLocation: CLLocationCoordinate2D!
    var markers: [GMSMarker] = []
    
    // MARK: - Default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    func focusMapToShowAllMarkers() {
        let myLocation: CLLocationCoordinate2D = self.markers.first!.position
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        
        for marker in self.markers {
            bounds = bounds.includingCoordinate(marker.position)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let devices = ScanDeviceViewController.shareInstance.devices
        
        // Remove all maker
        self.mapView.clear()
        self.markers.removeAll()
        
        // Reload maker
        devices.forEach { (device) in
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: device.latitude, longitude: device.longitude)
            marker.title = device.name
            marker.snippet = "Lat:" + device.latitude.description +
                "/n" + "Lng:" + device.longitude.description
            marker.map = mapView
            self.markers.append(marker)
        }
        
        focusMapToShowAllMarkers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    private func initComponent() {
        
        // Setup location manager
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        //locationManager.distanceFilter = 500
        locationManager.startUpdatingLocation()
        
        // Setup mapView
        //mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        //self.view.addSubview(mapView)
        //        mapView.button
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = false
        mapView.delegate = self
        mapView.padding = UIEdgeInsetsMake(0, 0, 60, 0)
        mapView.setMinZoom(1, maxZoom: 20)
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidClicked(_ sender: UIButton) {
        
        if let navigation = self.navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
}

// MARK: - Location Delegate

extension SearchDeviceViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            mapView.settings.compassButton = true
            //self.currentLocation
        } else if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = false
            mapView.settings.compassButton = true
        } else if status == .denied || status == .restricted {
            //self.showLocationSetting()
        } else if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            //self.isFirstTime = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            self.mapView.delegate = self
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: self.mapView.camera.zoom, bearing: 0, viewingAngle: 0)
            self.lastedLocation = location.coordinate
            self.currentLocation = location.coordinate
            // Add maker
            
            //loadMap(mapView.getRadius().description)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: { 
                
                self.locationManager.stopUpdatingLocation()
            })
        }
    }

}

// MARK: - GMSMapView Delegate


extension SearchDeviceViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
//        let detailProduct = TDetailProductOrShopViewController(nibName: "TDetailProductOrShopViewController", bundle: nil)
//        detailProduct.mapModel = marker.subMap
//        
//        self.navigationController?.pushViewController(detailProduct, animated: true)
    }
    
    @objc func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
//        let detailProduct = TDetailProductOrShopViewController(nibName: "TDetailProductOrShopViewController", bundle: nil)
//        detailProduct.mapModel = marker.subMap
//        if self.type == .Product {
//            detailProduct.state = .Product
//        } else {
//            detailProduct.state = .Shop
//        }
//        
//        self.navigationController?.pushViewController(detailProduct, animated: true)
        return true
    }
    
    @objc func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
//        self.labelAddessLevel.text = self.defineAddressLevel(position.zoom)
//        self.labelZoomLevel.text = String(format: "Zoom: %.1f", position.zoom)
//        if self.locationManager.location != nil {
//            self.bottomView.labelDistance.text = distance(position.target, point2: (self.locationManager.location?.coordinate)!).stringDistance()
//        }
        
    }
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
//        isDraging = true
//        self.labelAddessLevel.text = self.defineAddressLevel(mapView.camera.zoom)
//        self.labelZoomLevel.text = String(format: "Zoom: %.1f", mapView.camera.zoom)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        if isDraging == true {
//            isDraging = false
//            print("Stopped at position: \(mapView.camera.target)")
//            // do stuff
//            let visiableRegion = mapView.projection.visibleRegion()
//            let radiusOfCurrentView = distance(position.target, point2: visiableRegion.farLeft)
//            self.lastedLocation = self.lastedLocation != nil ? self.lastedLocation : position.target
//            self.currentLocation = self.lastedLocation
//            
//            let distanceWithLastedLocation = distance(position.target, point2: self.lastedLocation)
//            if position.zoom > 10 && distanceWithLastedLocation > radiusOfCurrentView  || fabs(position.zoom - self.curentZoom) > 1 {
//                
//                //                mapView.clear()
//                //                mapView.addPlaces(mapView.generateRamdomPlaces(mapView.camera.target))
//                self.loadMap(self.mapView.getRadius().description)
//                self.lastedLocation = mapView.camera.target
//            }
//            
//            if position.zoom < 7.0 {
//                
//                self.mapModel = TMapModel()
//                self.shopModel = TMapModel()
//                
//                if self.type == .Product {
//                    self.addProductMaker()
//                } else {
//                    self.addShopMaker()
//                }
//            }
//        }
    }
    
    func distance(_ point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        
        let location1 = CLLocation(coordinate: point1, altitude: 1, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: NSDate() as Date)
        let location2 = CLLocation(coordinate: point2, altitude: 1, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: NSDate() as Date)
        return location1.distance(from: location2).advanced(by: 0)
    }
    
}

