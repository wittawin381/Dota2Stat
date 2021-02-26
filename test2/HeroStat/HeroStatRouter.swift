//
//  HeroStatRouter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol HeroStatRouterLogic {
    
}

protocol HeroStatPassingData {
    var dataStore : HeroStatDataStore? { get set }
}

class HeroStatRouter : HeroStatRouterLogic, HeroStatPassingData {
    var dataStore: HeroStatDataStore?
    weak var viewControlelr : HeroStatViewLogic?
    
}
