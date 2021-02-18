//
//  MainTabBarController.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import UIKit

class MainTabBarController : UITabBarController {
    
    let peernav = UINavigationController()
    let homenav = UINavigationController()
    override func viewDidLoad() {
        peernav.navigationBar.prefersLargeTitles = true
        homenav.navigationBar.prefersLargeTitles = true
        let peer = RecordCoordinator(peernav)
        let home = HomeCoordinator(homenav)
        home.start()
        peer.start()
        viewControllers = [home.navigationController,peer.navigationController]
    }
}
