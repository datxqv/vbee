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
    @IBOutlet var titleLabel: VLabel!
    @IBOutlet weak var loginButton: VButton!
    @IBOutlet var forgotPasswordButton: VButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //@IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // Other
    var email: String = ""
    var accountMode: AccountAction = .SignUp
    
    // MARK: Default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Init
    private func initComponent() {
        
        //self.confirmPasswordTextField.isHidden = self.accountMode == .Login
        //self.actionButton.setTitle(self.accountMode.rawValue, for: .normal)
    }
    
    private func initData() {
        
        self.emailTextField.text = self.email
        self.emailTextField.isEnabled = false
    }
    
    // MARK: - Button Action
    @IBAction func loginButtonDidClicked(_ sender: UIButton) {
        if verify() {
            if self.accountMode == .Login {
                UserServices.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, complete: { (status, statusCode, data) in
                    if status {
                        //UIAlertController.customInit().showDefault(title: "OK!", message: "Success!")
                        UIApplication.shared.keyWindow?.rootViewController =  UTBaseNavigationController(rootViewController: TabbarController())
                    } else {
                        UIAlertController.customInit().showDefault(title: "Sorry!", message: "Have a problem!")
                    }
                })
            }
        }
    }
    
    @IBAction func forgotPasswordButtonDidClicked(_ sender: UIButton) {
        
        let forgotVCt = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        forgotVCt.mode = .reset
        self.navigationController?.pushViewController(forgotVCt, animated: true)
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
//            } else if self.confirmPasswordTextField.text?.isEmpty == true {
//                
//                 UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please type your password again!")
//                
//                return false
//            } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
//                UIAlertController.customInit().showDefault(title: "Sorry!", message: "Your confirm password not math!")
//                
//                return false
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
