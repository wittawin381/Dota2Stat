//
//  GameRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

protocol GameRouterLogic {
    func presentDetailModal()
}

protocol GameDataPassing {
    var dataStore : GameDataStore? { get set }
}

class GameRouter : GameRouterLogic, GameDataPassing {
    weak var viewController : GameView?
    var dataStore: GameDataStore?

    func presentDetailModal() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailModalView") as! DetailModalView
        passData(source: dataStore!, destination: &(vc.router!.dataStore!))
        navigate(source: viewController!, destination: vc)
    }
    
    func navigate(source : UIViewController, destination : UIViewController) {
        source.navigationController?.present(destination, animated: true, completion: {})
    }
    
    func passData(source : GameDataStore, destination : inout DetailDataStore) {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.detail = source.games?.players[selectedRow!]
    }
}
