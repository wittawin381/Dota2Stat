//
//  homeInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 22/2/2564 BE.
//

import Foundation
import Combine

protocol HomeBuisenessLogic {
    func fetch(request: Home.TableViewCell.Request)
}

protocol HomeDataStore {
    
}

class HomeInteractor : HomeBuisenessLogic, HomeDataStore {
    var presenter : HomePresenter?
    var subscription = Set<AnyCancellable>()
    func fetch(request: Home.TableViewCell.Request) {
        Publishers.Zip(OpenDota.shared.get(.matches, params: ["offset":0,"limit":"20"],withType: [Match].self),OpenDota.shared.get(.heroes, withType: [HeroesStat].self)).sink(receiveCompletion: {_ in }, receiveValue: { matches, stats in
            self.presenter?.presentItems(response: Home.TableViewCell.Response(matches: matches,heorStat: stats))
        }).store(in: &subscription)
    }
}
