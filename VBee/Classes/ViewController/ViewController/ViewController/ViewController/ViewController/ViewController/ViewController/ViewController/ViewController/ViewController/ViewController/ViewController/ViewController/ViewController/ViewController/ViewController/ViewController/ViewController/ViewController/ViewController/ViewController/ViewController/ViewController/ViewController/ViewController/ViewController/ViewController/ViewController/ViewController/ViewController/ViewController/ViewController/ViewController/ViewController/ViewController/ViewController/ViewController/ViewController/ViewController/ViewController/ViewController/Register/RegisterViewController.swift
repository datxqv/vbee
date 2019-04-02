//
//  RegisterViewController.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - IBOutet and Variable
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Init
    private func initComponent() {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    
    @IBAction func nextButtonDidClicked(_ sender: Any) {
        
        if verify() {
            
            UserServices.checkEmail(email: self.emailTextField.text!, complete: { (status, statusCode, data) in
                
                if status == true {
                    let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    loginViewController.accountMode = .Login
                    loginViewController.email = self.emailTextField.text!
                    
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                } else {
                    
                    let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                    loginViewController.accountMode = .SignUp
                    loginViewController.email = self.emailTextField.text!
                    
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            })
        }
    }
   
    func verify() -> Bool {
        
        if !(self.emailTextField.text?.isValidEmail())! {
            
            UIAlertController.customInit().showDefault(title: "Sorry!", message: "Please input your email string!")
            return false
        }
        
        return true
    }

}
