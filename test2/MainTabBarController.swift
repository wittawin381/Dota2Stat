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
    let peernav = UINavigationController()
    override func viewDidLoad() {
        recnav.navigationBar.prefersLargeTitles = true
        homenav.navigationBar.prefersLargeTitles = true
        initHome()
        initRecordView()
        initPeersView()
        viewControllers = [homenav,recnav,peernav]
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
        recnav.tabBarItem = UITabBarItem(title: "Record", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        recnav.pushViewController(vc, animated: true)
    }
    
    func initPeersView() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PeersView") as! PeersView
        peernav.tabBarItem = UITabBarItem(title: "Peers", image: UIImage(systemName: "square.grid.2x2"), tag: 2)
        peernav.pushViewController(vc, animated: true)
    }
}
