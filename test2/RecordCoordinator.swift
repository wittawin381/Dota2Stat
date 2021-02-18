//
//  HomeCoordinator.swift
//  test2
//
//  Created by Wittawin Muangnoi on 17/2/2564 BE.
//

import Foundation
import UIKit

class RecordCoordinator : Coordinator {
    var childCoordinator: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    func start() {
        let vc = RecordView.instantiate()
        let vm = RecordVM()
        vc.coordinator = self
        vc.viewModel = vm
        vc.tabBarItem = UITabBarItem(title: "Record", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        navigationController.pushViewController(vc, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
