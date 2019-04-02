//
//  DeviceConfigure.swift
//  VBee
//
//  Created by daicashigeru on 4/1/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import GoogleMaps

protocol DeviceConfigureDelegate: NSObjectProtocol {
    
    func didSelectType(peripheralData: CBPeripheralData,type: TypeModel)
    
}
class DeviceConfigure: UIView {

    // IBOutlet and Variable
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var selectTypeTextField: UITextField!
    @IBOutlet weak var cancelButton: VButton!
    @IBOutlet weak var saveButton: VButton!
    
    // Map
    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var lastedLocation: CLLocationCoordinate2D!
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 20.9974, longitude: 105.8266)
    var myLocation: CLLocationCoordinate2D!
    
    // Picker
    let typePickerView = UIPickerView()
    var arrayType: [TypeModel]  = []
    var peripheralData: CBPeripheralData?
    var deviceModel: DeviceModel?
    var typeSelected: TypeModel?
    // Delegate
    var delegate: DeviceConfigureDelegate?
    
    
    // MARK: - Custom init
    class func customInit() -> DeviceConfigure {
        let view = Bundle.main.loadNibNamed("DeviceConfigure", owner: self, options: nil)!.first as? DeviceConfigure
        
        return view!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initComponent()
        initData()
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
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = false
        mapView.delegate = self
        mapView.padding = UIEdgeInsetsMake(0, 0, 60, 0)
        mapView.setMinZoom(1, maxZoom: 20)
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        
        // Set up pickerView
        typePickerView.delegate = self
        typePickerView.dataSource = self
        self.selectTypeTextField.inputView = typePickerView
    }
    
    // MARK: - Init
    private func initData() {
        
        arrayType = [TypeModel(imageName: "pet_128", name: "Thú cưng"), TypeModel(imageName: "key_128", name: "Chìa khoá"),TypeModel(imageName: "icon_tui_128", name: "Túi đựng")]
        
        for i in 0..<arrayType.count {
            
            var element = arrayType[i]
            element.id = i + 1
        }
        
    }
    

    // MARK: - Action
    @IBAction func cancelButtonDidClicked(_ sender: UIButton) {
        
        TCustomAlertController.sharedInstance.hidden()
    }
    
    @IBAction func saveButtonDidClicked(_ sender: UIButton) {
        
        if verifyInformation() {
            
            var macString = ""
            var curentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 21.028472, longitude: 05.854167)
            if let location = self.locationManager.location {
                curentLocation = location.coordinate
            }
            // Create new device
            if let delegate = self.delegate, let data = self.peripheralData, let typeSelect = self.typeSelected {
                
                macString = data.macAddress!
                data.getInfor()
                data.customType = typeSelect
                data.lat = String(curentLocation.latitude)
                data.long = String(curentLocation.longitude)
                data.customName = nameTextField.text!
                delegate.didSelectType(peripheralData: data, type: typeSelect)
            }
            
            // Update existed device
            if let device = self.deviceModel, let delegate = self.delegate {
                macString = device.mac
                let data = CBPeripheralData()
                data.customType = self.typeSelected!
                data.lat = String(curentLocation.latitude)
                data.long = String(curentLocation.longitude)
                data.customName = nameTextField.text!
                
                delegate.didSelectType(peripheralData: data, type: self.typeSelected!)
            }
            
            // Update
            DispatchQueue.main.async(execute: { 
                showLoading()
                UserServices.updateDevice(mac: macString, name: self.nameTextField.text!, categoryID: (self.typeSelected?.id)!, lat: Float(curentLocation.latitude), lng: Float(curentLocation.longitude), complete: { (status, statusCode, data) in
                    hideLoading()
                    
                    if status {
                        print("Update thanh cong!")
                        ScanDeviceViewController.shareInstance.initData()
                    }
                })
            })
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        
        self.nameTextField.resignFirstResponder()
        self.selectTypeTextField.resignFirstResponder()
        self.resignFirstResponder()
    }
    
    // MAKR: - Verify information
    func verifyInformation() -> Bool {
        
        if nameTextField.text?.isEmpty == true {
            UIAlertController.customInit().showDefault(title: "Xin hãy nhập tên thiết bị", message: "", complete: { 
                
            })
            return false
        } else if typeSelected == nil {
            
            UIAlertController.customInit().showDefault(title: "Xin hãy chọn loại thiết bị", message: "", complete: { 
                
            })
            return false
        }
        
        return true
    }
}

// MARK: - PickerView Delegate

extension DeviceConfigure: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        return TypeView.initWith(model: arrayType[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        typeSelected = arrayType[row]
        self.selectTypeTextField.text = typeSelected?.name
        self.nameTextField.resignFirstResponder()
        self.selectTypeTextField.resignFirstResponder()
    }
}

// MARK: - Location Delegate
extension DeviceConfigure: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = false
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
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
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
extension DeviceConfigure: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    func distance(_ point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double {
        
        let location1 = CLLocation(coordinate: point1, altitude: 1, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: NSDate() as Date)
        let location2 = CLLocation(coordinate: point2, altitude: 1, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: NSDate() as Date)
        return location1.distance(from: location2).advanced(by: 0)
    }
    
}

