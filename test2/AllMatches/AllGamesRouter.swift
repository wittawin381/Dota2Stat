//
//  AllGamesRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation
import UIKit

protocol AllGamesRouterLogic {
    func routeToGame(matchID: String)
}

protocol AllGamesDataPassing {
    var dataStore : AllGamesDataStore? { get set }
}


class AllGamesRouter : AllGamesDataPassing, AllGamesRouterLogic {
    var dataStore: AllGamesDataStore?
    weak var viewController : AllGamesView?
    
    func routeToGame(matchID: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GameView") as! GameView
        passDataToGame(source: dataStore!, destination: &(vc.router!.dataStore!), matchID: matchID)
        navigateTo(source: viewController!, destination: vc)
    }
    
    func navigateTo(source : AllGamesView, destination : UIViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToGame(source : AllGamesDataStore, destination : inout GameDataStore, matchID: String) {
        destination.match_id = matchID
    }
    
}
