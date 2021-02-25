//
//  MainTabBarController.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import UIKit

class MainTabBarController : UITabBarController {
//    let homeTab =
    let recnav = UINavigationController()
    let homenav = UINavigationController()
    override func viewDidLoad() {
        recnav.navigationBar.prefersLargeTitles = true
        homenav.navigationBar.prefersLargeTitles = true
        initHome()
        initRecordView()
        viewControllers = [homenav,recnav]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initHome() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
        homenav.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "house"), tag: 0)
        homenav.pushViewController(vc, animated: true)
        
    }
    
    func initRecordView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RecordView") as! RecordView
        recnav.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "house"), tag: 0)
        recnav.pushViewController(vc, animated: true)
    }
}
