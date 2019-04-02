//
//  CharactersViewController.swift
//  VBee
//
//  Created by datxqv on 3/12/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharactersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var nibString = "CharacterCell"
    var listViewController = ListServicesViewController(nibName: "ListServicesViewController", bundle: nil)
    var serviceData: ServiceData = ServiceData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Init
    private func initComponent() {
        
        // Init tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
}

// MARK: UITableView delegate

extension CharactersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.serviceData.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString) as! CharacterCell
        
        let character = self.serviceData.characters[indexPath.row]
        var string = ""
        
        //var dataString = String(data: data!, encoding: String.Encoding.utf8)
        
        cell.fillData(charaterName: "Unknown characteristic " + indexPath.row.description, character: character)
        
        return cell
    }
}

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let character = serviceData.characters[indexPath.row]
        self.writeCharacter(character: character, string: "Character " + indexPath.row.description)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.tableView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.tableView.reloadData()
    }
}

extension CharactersViewController {
    
    func writeCharacter(character: CBCharacteristic, string: String, description: String = "Character") {
        
        if character.permissions.contains(.write) {
            
            let alertController = UIAlertController(title: description, message: "Type a value", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            })
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: "Write", style: .default, handler: { (action) in
                
                if let textField = alertController.textFields?[0] {
                    
                    if textField.text?.isEmpty == false, let intValue = UInt8(textField.text!) {
                        
                        let enableValue:[UInt8] = [intValue]
                        let enableBytes = Data(bytes: enableValue)
                            //NSData(bytes: &enableValue, length: sizeof(UInt8))
                        //self.scanViewController.peripheral.delegate = self.scanViewController
                        self.listViewController.peripheralData?.peripheral?.writeValue(enableBytes, for: character, type: .withResponse)
                        //self.scanViewController.peripheral.readValue(for: character)
                    }
                }
            })
            
            alertController.addAction(okAction)
            alertController.addTextField(configurationHandler: { (textField) in
                
            })
            
            self.present(alertController, animated: true, completion: { 
                
            })
        }
    }
}

extension CharactersViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        for character in self.serviceData.characters {
            self.listViewController.peripheralData?.peripheral?.readValue(for: character)
            
            print("\(character)\n")
        }
    }
}

