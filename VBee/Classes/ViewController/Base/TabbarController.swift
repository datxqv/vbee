//
//  TabbarController.swift
//  SoundWorld
//
//  Created by PaditechDev1 on 3/31/16.
//  Copyright © PaditechDev1. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController , UITabBarControllerDelegate{
    
    static let sharedIntance: TabbarController = TabbarController()
    
    //MARK: - Variable and IBOutlet
    var lastSelectedIndex : NSInteger = 0
    var requiredIndex: NSInteger = 0
    var tabbarHeight : CGFloat = 0.0
    @IBOutlet var footerView : UIView?
    var firstLoad: Bool = true
    var preventAppear: Bool = false
    
    //MARK: - Life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initTabbarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        if self.firstLoad {
            
//            self.delegate?.tabBarController!(self, shouldSelectViewController: self.viewControllers![0])
            self.selectedIndex = 0
            self.firstLoad = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //requestAudioPermission()
        
        if let controller = self.selectedViewController {
            controller.viewDidAppear(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Init tabbar item
    func initTabbarItem()-> Void {
        
        // Set delegate
        self.delegate = self
        
        // Setup ViewController1
        let vc1 = ScanDeviceViewController.shareInstance
        vc1.title = LANGTEXT(key: "TITLE_SEARCH")
        let icon1 = UITabBarItem(title: LANGTEXT(key: ""), image: UIImage(named: "icon_home")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_home")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        vc1.tabBarItem = icon1
        
        // Setup ViewController2
        let vc2 = SearchDeviceViewController(nibName: "SearchDeviceViewController", bundle: nil)
        vc2.title = LANGTEXT(key: "TITLE_FAVORITE")
        let icon2 = UITabBarItem(title: LANGTEXT(key: ""), image: UIImage(named: "icon_map")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_map")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        vc2.tabBarItem = icon2
        
        // Setup ViewController3
        let vc3 = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
        vc3.title = LANGTEXT(key: "TITLE_MESSAGE")
        let icon3 = UITabBarItem(title: LANGTEXT(key: ""), image: UIImage(named: "icon_bluetooth")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_bluetooth")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        vc3.tabBarItem = icon3
        
        // Setup ViewController4
        let vc4 = UIViewController()
        vc4.title = LANGTEXT(key: "TITLE_SETTING")
        let icon4 = UITabBarItem(title: LANGTEXT(key: ""), image: UIImage(named: "icon_buy")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_buy")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        vc4.tabBarItem = icon4
        
        // Setup ViewController4
        let vc5 = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        vc5.title = LANGTEXT(key: "TITLE_SETTING")
        let icon5 = UITabBarItem(title: LANGTEXT(key: ""), image: UIImage(named: "icon_setting")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_setting")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        vc5.tabBarItem = icon5
        
        
        // Navigation
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.navigationBar.barTintColor = Constants.Rgb2UIColor(red: 63, green: 123, blue: 184)
        //nav1.interactivePopGestureRecognizer?.enabled = false
        nav1.isNavigationBarHidden = true
        
        
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.navigationBar.barTintColor = Constants.Rgb2UIColor(red: 63, green: 123, blue: 184)
        nav2.isNavigationBarHidden = true
        
        let nav3 = UINavigationController(rootViewController: vc3)
        nav3.navigationBar.barTintColor = Constants.Rgb2UIColor(red: 63, green: 123, blue: 184)
        nav3.isNavigationBarHidden = true
        
        let nav4 = UINavigationController(rootViewController: vc4)
        nav4.navigationBar.barTintColor = Constants.Rgb2UIColor(red: 63, green: 123, blue: 184)
        nav4.isNavigationBarHidden = true
        
        let nav5 = UINavigationController(rootViewController: vc5)
        nav5.navigationBar.barTintColor = Constants.Rgb2UIColor(red: 63, green: 123, blue: 184)
        nav5.isNavigationBarHidden = true
        
        self.viewControllers = [vc1, vc2, vc3, vc4, vc5]
        

    }
    
    //MARK: - Custom tabbar
    func initComponent()-> Void {
        /*
        let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        
        if(SCREEN_HEIGHT <= 568){
            tabbarHeight = 49
        } else if (SCREEN_HEIGHT <= 667){
            tabbarHeight = 60
        } else {
            tabbarHeight = 65
        }
        
        // Setup ViewController
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.yellowColor()
        vc1.title = Constants.LANGTEXT("TITLE_HOME")
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc2.title = Constants.LANGTEXT("TITLE_CATEGORY")
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.blueColor()
        vc3.title = Constants.LANGTEXT("TITLE_POST")
        
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.orangeColor()
        vc4.title = Constants.LANGTEXT("TITLE_MY_PAGE")
        
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.brownColor()
        vc5.title = Constants.LANGTEXT("TITLE_OTHER")
        
        // Navigation
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        let nav5 = UINavigationController(rootViewController: vc5)
        self.viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        lastSelectedIndex = 0
        
        // Settup tabbar
        footerView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width,  tabbarHeight))
        footerView?.backgroundColor = UIColor.whiteColor()
        let numberOfButton = 5
        let buttonImageArray = ["tabbar_icon_home", "tabbar_icon_category", "tabbar_qbutton", "tabbar_icon_my", "tabbar_icon_other"]
        
        for i in 0...numberOfButton - 1{
            let buttonName : String = buttonImageArray[i];
            let buttonFrame = CGRectMake(SCREEN_WIDTH/5 * CGFloat(i), 0, SCREEN_WIDTH/5, tabbarHeight)
            let button = customButton(buttonFrame, imageNamed: buttonName)
            button.tag = i + 10
            footerView?.addSubview(button)
            if i == 0 {
                buttonTapped(button)
            }
        }
        
        self.tabBar.addSubview(footerView!)
        UITabBar.appearance().backgroundColor = UIColor.whiteColor()
 
 */
        
    }
    
    //MARK: - Tabbar controller delegate
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        self.lastSelectedIndex = self.selectedIndex
        
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
//        if (self.selectedIndex == 3 || self.selectedIndex == 2) {//!User.sharedUser.isLogin() {
//            
//            // backup require index
//            self.preventAppear = true
//            self.requiredIndex = self.selectedIndex
//            
//            self.selectedIndex = self.lastSelectedIndex
//            // if user do not sign in, require use to login
//            
//            //AlamofireClient.sharedInstance.ShowAlertRequireLogin()
//            
//        }
    }
    
}
