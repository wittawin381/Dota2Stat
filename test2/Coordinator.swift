////
////  Coordinator.swift
////  test2
////
////  Created by Wittawin Muangnoi on 16/2/2564 BE.
////
//
//import Foundation
//import UIKit
//
//protocol Coordinator {
//    var childCoordinator : [Coordinator] { get set }
//    var navigationController : UINavigationController { get set }
//    func start()
//}
//
//
//class HomeCoordinator : Coordinator {
//    var childCoordinator = [Coordinator]()
//    var navigationController: UINavigationController
//    
//    enum TabController {
//        case home
//        case peer
//    }
//    
//    init(_ navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        let vc = ViewController.instantiate()
////        let vm = HomeVM()
//        vc.coordinator = self
////        vc.viewModel = vm
//        navigationController.pushViewController(vc, animated: true)
//        navigationController.tabBarItem = UITabBarItem(title: "Overview", image: UIImage(systemName: "house"), tag: 0)
//    }
//    
//    
//    func toAllGamesView() {
//        let vc = AllGamesView.instantiate()
//        vc.coordinator = self
//        navigationController.pushViewController(vc, animated: true)
//        
//    }
//    
//    func toHeroStatView() {
//        let vc = HeroStatView.instantiate()
//        navigationController.pushViewController(vc, animated: true)
//    }
//}
//
//
//
