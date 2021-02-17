//
//  MainTabBarController.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import UIKit

class MainTabBarController : UITabBarController {
    let home = MainCoordinator(UINavigationController())
    let peer = MainCoordinator(UINavigationController())
    override func viewDidLoad() {
        home.start(.home)
        peer.start(.peer)
        viewControllers = [home.navigationController,peer.navigationController]
    }
}
