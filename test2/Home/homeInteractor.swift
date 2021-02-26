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
    var games : [Match]? { get }
    var stats : [HeroesStat]? { get }
    var match_id : String! { get set }
}

class HomeInteractor : HomeBuisenessLogic, HomeDataStore {
    var presenter : HomePresenter?
    var subscription = Set<AnyCancellable>()
    var games : [Match]?
    var stats : [HeroesStat]?
    var match_id: String!
    func fetch(request: Home.TableViewCell.Request) {
        Publishers.Zip(OpenDota.shared.get(.matches, params: ["offset":0,"limit":"20"],withType: [Match].self),OpenDota.shared.get(.heroes, withType: [HeroesStat].self)).sink(receiveCompletion: {_ in }, receiveValue: {[unowned self] matches, stats in
            self.games = matches
            self.stats = stats
            self.presenter?.presentItems(response: Home.TableViewCell.Response(matches: matches,heorStat: stats))
        }).store(in: &subscription)
    }
}
