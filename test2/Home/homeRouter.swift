//
//  homeRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation
import UIKit

protocol HomeRouterLogic {
    func routeToAllGames()
    func routeToHeroStat()
}

protocol HomeRouterDataPassing {
    var dataStore : HomeDataStore? { get }
}


class HomeRouter : HomeRouterDataPassing, HomeRouterLogic {
    weak var viewController : UIViewController?
    var dataStore : HomeDataStore?
    func routeToAllGames() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AllGamesView") as! AllGamesView
//        let dataStore = vc
        navigate(to: vc, from: viewController!)
    }
    
    func routeToHeroStat() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HeroStatView") as! AllGamesView
        navigate(to: vc, from: viewController!)
    }
    
    func navigate(to destination: UIViewController, from source: UIViewController){
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    
}
