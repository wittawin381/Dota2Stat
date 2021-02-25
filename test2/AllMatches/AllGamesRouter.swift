//
//  AllGamesRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation

protocol AllGamesRouterLogic {
    
}

protocol AllGamesDataPassing {
    var dataStore : AllGamesDataStore? { get set }
}


class AllGamesRouter : AllGamesDataPassing, AllGamesRouterLogic {
    var dataStore: AllGamesDataStore?
    weak var viewController : AllGamesView?
    
}
