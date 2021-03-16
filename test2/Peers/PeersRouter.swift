//
//  PeersRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import Foundation


protocol PeersRoutingLogic {
    
}

protocol PeersDataPassing {
    var dataStore : PeersDataStore? { get set }
}

class PeersRouter : PeersRoutingLogic, PeersDataPassing {
    var dataStore: PeersDataStore?
    weak var viewController : PeersView?
    
}
