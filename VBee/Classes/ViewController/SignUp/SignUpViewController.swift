//
//  SignUpViewController.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: IBOutlet and variable
    
    @IBOutlet var scrollBackground: UIScrollView!
    
    // Step 1
    @IBOutlet var step1View: UIView!
    @IBOutlet var searchTextField: UITextField!
    
    // Step 2
    @IBOutlet var step2View: UIView!
    @IBOutlet var emailTextField: VTextField!
    @IBOutlet var passwordTextField: VTextField!
    @IBOutlet var confirmPasswordTextField: VTextField!
    @IBAction func signUpButtonDidClicked(_ sender: UIButton) {
        
    }
    
    var currentPage: Int = 0 {
        didSet {
            let targerPoint = CGPoint.init(x: CGFloat(currentPage) * scrollBackground.frame.width, y: 0)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.scrollBackground.setContentOffset(targerPoint, animated: false)
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpScrollView()
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Action
    
    @IBAction func backButton2DidClicked(_ sender: UIButton) {
        
        emailTextField.text = ""
        currentPage = 0
    }
    
    @IBAction func registerButtonDidClicked(_ sender: UIButton) {
        
        if verifySignUp(){
            showLoading()
            UserServices.register(email: self.emailTextField.text!, password: self.passwordTextField.text!, complete: { (status, statusCode, data) in
                hideLoading()
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

extension SignUpViewController {
    
    func setUpScrollView() {
        
        step1View.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        step2View.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        scrollBackground.addSubview(step1View)
        scrollBackground.addSubview(step2View)
        currentPage = 0
        hideKeyboardWhenTappedAround()
    }
    
    func setUp() {
        
        self.searchTextField.delegate = self
    }
    
    // MARK: - Verify information
    func verify() -> Bool {
        
        if self.searchTextField.text?.isValidEmail() == false {
            
            UIAlertController.customInit().showDefault(title: "", message: "Xin hãy nhập email của bạn!", complete: {
                self.searchTextField.text = ""
            })
            
            return false
        }
        return true
    }
    
    func verifySignUp() -> Bool {
        
        if self.searchTextField.text?.isValidEmail() == false {
            
            UIAlertController.customInit().showDefault(title: "", message: "Xin hãy nhập email của bạn!", complete: {
                self.searchTextField.text = ""
            })
            
            return false
        } else if self.passwordTextField.text?.isEmpty == true {
            UIAlertController.customInit().showDefault(title: "", message: "Xin hãy nhập mật khẩu của bạn", complete: {
                
            })
            
            return false
        } else if self.passwordTextField.text != self.confirmPasswordTextField.text {
            UIAlertController.customInit().showDefault(title: "", message: "Xin hãy xác nhận lại mật khẩu", complete: {
                
            })
            
            return false
        }
        
        return true
    }
    
    // MARK: - Check email
    func checkEmail() {
        
        showLoading()
        UserServices.checkEmail(email: self.searchTextField.text!, complete: { (status, statusCode, data) in
            hideLoading()
            if status == true {
                let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
                loginViewController.accountMode = .Login
                loginViewController.email = self.searchTextField.text!
                Constants.kEmail = self.searchTextField.text!
                self.navigationController?.pushViewController(loginViewController, animated: true)
            } else {
                
                self.currentPage = 1
                self.emailTextField.isEnabled = false
                self.emailTextField.text = self.searchTextField.text
            }
        })

    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if verify() {
            checkEmail()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            
            if verify() {
                checkEmail()
            }
            return false
        }
        return true
    }
}
