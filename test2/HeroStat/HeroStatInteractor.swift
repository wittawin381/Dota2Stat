//
//  HeroStatInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol HeroStatBusinessLogic {
    func displayItems(request: HeroStat.Cell.Request)
}

protocol HeroStatDataStore {
    var stats : [HeroesStat] { get set }
}

class HeroStatInteractor : HeroStatBusinessLogic, HeroStatDataStore {
    var presenter : HeroStatPresentLogic?
    var stats = [HeroesStat]()
    
    func displayItems(request: HeroStat.Cell.Request) {
        presenter?.presentItems(response: HeroStat.Cell.Response(stats: stats))
    }
    
}
