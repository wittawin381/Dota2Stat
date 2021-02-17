//
//  Coordinator.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator : [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    func start()
}


class MainCoordinator : Coordinator {
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    enum TabController {
        case home
        case peer
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        vc.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "house"), tag: 0)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func start(_ tab : TabController) {
        switch tab {
        case .home:
            let vc = ViewController.instantiate()
            vc.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "house"), tag: 0)
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        case .peer:
            let vc = RecordView.instantiate()
            vc.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "house"), tag: 0)
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func toAllGamesView() {
        let vc = AllGamesView.instantiate()
        let vm = AllGamesVM()
        vc.viewModel = vm
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
        
    }
    
    func toHeroStatView() {
        let vc = HeroStatView.instantiate()
        let vm = HeroStatVM()
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
    }
}



