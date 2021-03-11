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
    func routeToAllGamesByHero()
    func routeToGame()
}

protocol HomeRouterDataPassing {
    var dataStore : HomeDataStore? { get }
}


class HomeRouter : HomeRouterDataPassing, HomeRouterLogic {
    weak var viewController : ViewController?
    var dataStore : HomeDataStore?
    func routeToAllGames() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AllGamesView") as! AllGamesView
        passDataToAllGames(source: dataStore!  , destination: &(vc.router!.dataStore!) )
        navigate(to: vc, from: viewController!)
    }
    
    func routeToHeroStat() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HeroStatView") as! HeroStatView
        passDataToHeroStat(source: dataStore!, destination: &(vc.router!.dataStore!))
        navigate(to: vc, from: viewController!)
    }
    
    func routeToGame() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GameView") as! GameView
        passDataToGame(source: dataStore!, destination: &(vc.router!.dataStore!))
        navigate(to: vc, from: viewController!)
    }
    
    func routeToAllGamesByHero() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AllGamesView") as! AllGamesView
        passDataToAllGamesByHero(source: dataStore!  , destination: &(vc.router!.dataStore!) )
        navigate(to: vc, from: viewController!)
    }
    
    func navigate(to destination: UIViewController, from source: UIViewController){
        source.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func passDataToAllGames(source : HomeDataStore, destination : inout AllGamesDataStore) {
        destination.games = source.games!
    }
    
    func passDataToAllGamesByHero(source : HomeDataStore, destination : inout AllGamesDataStore) {
        destination.mode = .byHero
        let index = viewController?.listTable.indexPathForSelectedRow?.row
        destination.heroID = Int(source.stats![index!].hero_id!)
    }
    
    func passDataToHeroStat(source : HomeDataStore, destination : inout HeroStatDataStore) {
        destination.stats = source.stats!
    }
    
    func passDataToGame(source : HomeDataStore, destination : inout GameDataStore) {
        let selectedRow = viewController?.listTable.indexPathForSelectedRow?.row
        destination.match_id = String((source.games?[selectedRow!].match_id)!)
    }
    
}
