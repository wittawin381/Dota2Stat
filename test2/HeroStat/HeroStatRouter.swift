//
//  HeroStatRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

protocol HeroStatRouterLogic {
    func routeToAllGamesByHero()
}

protocol HeroStatPassingData {
    var dataStore : HeroStatDataStore? { get set }
}

class HeroStatRouter : HeroStatRouterLogic, HeroStatPassingData {
    var dataStore: HeroStatDataStore?
    weak var viewController : HeroStatView?
    
    func routeToAllGamesByHero() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AllGamesView") as! AllGamesView
        passDataToAllGamesByHero(source: dataStore!  , destination: &(vc.router!.dataStore!) )
        navigate(to: vc, from: viewController!)
    }
    
    func passDataToAllGamesByHero(source : HeroStatDataStore, destination : inout AllGamesDataStore) {
        destination.mode = .byHero
        let index = viewController?.listTable.indexPathForSelectedRow?.row
        destination.heroID = Int(source.stats[index!].hero_id!)
    }
    
    func navigate(to destination: UIViewController, from source: UIViewController){
        source.navigationController?.pushViewController(destination, animated: true)
        
    }
}
