//
//  GameRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol GameRouterLogic {
    
}

protocol GameDataPassing {
    var dataStore : GameDataStore? { get set }
}

class GameRouter : GameRouterLogic, GameDataPassing {
    weak var viewController : GameViewLogic?
    var dataStore: GameDataStore?

}
