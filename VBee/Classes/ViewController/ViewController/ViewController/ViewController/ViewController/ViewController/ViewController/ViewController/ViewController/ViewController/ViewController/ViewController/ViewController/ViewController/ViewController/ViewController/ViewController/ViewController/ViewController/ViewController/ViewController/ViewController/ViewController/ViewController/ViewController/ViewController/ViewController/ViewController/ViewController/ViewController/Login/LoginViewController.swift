//
//  LoginViewController.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

enum AccountAction: String {
    
    case Login = "Login"
    case SignUp = "Sign up"
}
class LoginViewController: UIViewController {

    // MARK: - Variable and IBOutlet
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordBottomContraint: NSLayoutConstraint!
    
    var email: String = ""
    var accountMode: AccountAction = .SignUp
    // MARK: Default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Init
    private func initComponent() {
        
        self.confirmPasswordTextField.isHidden = self.accountMode == .Login
        self.passwordBottomContraint.constant = self.accountMode == .Login ? 8 : 50
        self.actionButton.setTitle(self.accountMode.rawValue, for: .normal)
    }
    
    private func initData() {
        
        self.emailTextField.text = self.email
        self.emailTextField.isEnabled = false
    }
    
    // MARK: - Button Action
    
    @IBAction func buttonActionDidClicked(_ sender: Any) {
        
        if verify() {
            
            if self.accountMode == .SignUp {
                
                UserServices.register(email: self.emailTextField.text!, password: self.passwordTextField.text!, complete: { (status, statusCode, data) in
                    
                    if status {
                        //UIAlertController.customInit().showDefault(title: "OK!", message: "Success!")
                        self.navigationController?.pushViewController(ScanDeviceViewController(nibName: "ScanDeviceViewController", bundle: nil), animated: true)
                    } else {
                        
                        UIAlertController.customInit().showDefault(title: "Sorry!", message: "Have a problem!")
                    }
                })
            }
        }
        
    }
    
    // MARK: - Check information
    
    private func verify() -> Bool {
        
        if self.accountMode == .SignUp {
            
            if self.emailTextField.text?.isValidEmail() == false {
                 UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please input your email string!")
                return false
            } else if self.passwordTextField.text?.isEmpty == true {
                 UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please input your password string!")
                return false
            } else if self.confirmPasswordTextField.text?.isEmpty == true {
                
                 UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please type your password again!")
                
                return false
            } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
                UIAlertController.customInit().showDefault(title: "Sorry!", message: "Your confirm password not math!")
                
                return false
            } else {
                
                return true
            }
        } else {
            if self.emailTextField.text?.isValidEmail() == false {
                UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please input your email string!")
                return false
            } else if self.passwordTextField.text?.isEmpty == true {
                UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please input your password string!")
                return false
            } else {
                
                return true
            }

            
        }
    }
}
