//
//  SettingsViewController.swift
//  VBee
//
//  Created by daicashigeru on 7/29/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Variable and IBOutlet
    @IBOutlet var tableView: UITableView!
    
    var arrayData: [String] = [LANGTEXT(key: "Đổi mật khẩu")]
    // MARK: - Life cycle
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
    

    // MARK: - Init component
    func initComponent() {
        
    }
    
    func initData() {
        
        // Setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellNibName)
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 10, right: 0)
    }
    
}

// MARK: - UITableView Data Source
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            
            return 1
        } else {
            
            return arrayData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.section == 1 {
            cell.textLabel?.text = LANGTEXT(key: "Đăng xuất")
            cell.textLabel?.textColor = UIColor.red
        } else {
            
            cell.textLabel?.text = arrayData[indexPath.row]
            cell.textLabel?.textColor = UIColor.black
        }
        //configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UITableView Delegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            UIAlertController.customInit().showDefault(title: LANGTEXT(key: "Bạn có muốn đăng xuất?"), message: LANGTEXT(key: "Mọi dữ liệu của bạn sẽ bị xoá, đăng nhập lại để tiếp tục sử dụng"), complete: { 
                
                Constants.kEmail = ""
                Constants.kAccessToken = ""
                let navigationCtr =  UINavigationController(rootViewController: SignUpViewController(nibName: "SignUpViewController", bundle: nil))
                navigationCtr.isNavigationBarHidden = true
                UIApplication.shared.keyWindow?.rootViewController = navigationCtr
            })
        } else {
            
            switch indexPath.row {
            case 0:
                
                let changePasswordVct = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
                changePasswordVct.mode = .change
                self.navigationController?.pushViewController(changePasswordVct, animated: true)
                break
            default:
                
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return 70.0
        } else {
            
            return 30.0
        }
    }
}
