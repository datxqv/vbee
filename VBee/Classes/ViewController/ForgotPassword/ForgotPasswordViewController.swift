//
//  ForgotPasswordViewController.swift
//  VBee
//
//  Created by daicashigeru on 5/1/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

enum PasswordAction {
    
    case change, reset
}
class ForgotPasswordViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var navigationView: VView!
    @IBOutlet var titleLabel: UIButton!
    @IBOutlet var oldPasswordTextField: VTextField!
    @IBOutlet var newPasswordTextField: VTextField!
    @IBOutlet var changePasswordButton: VButton!
    
    // Model
    var email: String = ""
    var mode: PasswordAction = .change
    
    // MARK: - Default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initComponent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    private func initComponent() {
        
        self.newPasswordTextField.isHidden = mode == .reset
        self.oldPasswordTextField.isHidden = mode == .reset
        self.changePasswordButton.setTitle(mode == .reset ? "Reset": "Change password", for: .normal)
    }
    
    // MARK: - Action
    @IBAction func changePasswordButtonDidClicked(_ sender: UIButton) {
        
        if mode == .reset {
            
            showLoading()
            UserServices.resetPassword(email: Constants.kEmail, complete: { (status, statusCode, data) in
                hideLoading()
                
                if status {
                    UIAlertController.customInit().showDefault(title: "Success", message: "Please check your email.", complete: {
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    UIAlertController.customInit().showDefault(title: "Failed", message: "Please try againt.", complete: {
                        
                    })
                }
            })
            // Reset
        } else {
            
            if verify() {
                // Change password
                showLoading()
                UserServices.updatePassword(email: Constants.kEmail, newPassword: newPasswordTextField.text!, complete: { (status, statusCode, data) in
                    
                    hideLoading()
                    
                    if status {
                        UIAlertController.customInit().showDefault(title: "Success", message: "Please check your email.", complete: { 
                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        UIAlertController.customInit().showDefault(title: "Failed", message: "Please try againt.", complete: {
                        })
                    }
                })
            }
            
        }
    }
    
    func verify() -> Bool {
        
        if !(self.newPasswordTextField.text!.characters.count > 5) {
            
            UIAlertController.customInit().showDefault(title: "Sorry!", message: "Your password must be have more than 6 character")
            return false
        }
        
        return true
    }
    
    @IBAction func backButtonDidClicked(_ sender: UIButton) {
        if let navigation = self.navigationController {
            
            navigation.popViewController(animated: true)
        }
    }
}
