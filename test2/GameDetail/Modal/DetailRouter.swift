//
//  DetailRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation


protocol DetailRouterLogic {
    
}

protocol DetailDataPassing {
    var dataStore : DetailDataStore? { get set }
}

class DetailRouter : DetailRouterLogic, DetailDataPassing {
    weak var viewController : DetailModalView?
    var dataStore: DetailDataStore?
}
