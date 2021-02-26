//
//  AllGamesInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation
import Combine

protocol AllGamesBusinessLogic {
    var isLoading : Bool { get set }
    func showItems(request: AllGames.Cell.Request)
    func fetchMore(request: AllGames.Cell.Request)
}

protocol AllGamesDataStore {
    var games : [Match] { get set }
}

class AllGamesInteractor : AllGamesBusinessLogic, AllGamesDataStore{
    var games: [Match] = [Match]()
    var presenter : AllGamesPresentLogic?
    var isLoading = false
    var subscription = Set<AnyCancellable>()
    func fetchMore(request: AllGames.Cell.Request) {
        if !isLoading {
            isLoading = true
            OpenDota.shared.get(.matches,params: ["limit":20,"offset":games.count],withType: [Match].self).sink(receiveCompletion: {_ in }, receiveValue: {[unowned self] value in
                self.games += value
                self.isLoading = false
                self.presenter?.presentMoreItems(response: AllGames.Cell.Response(items: value))
            }).store(in: &subscription)
        }
    }
    
    func showItems(request: AllGames.Cell.Request) {
        presenter!.presentItems(response: AllGames.Cell.Response(items: games) )
    }
}
