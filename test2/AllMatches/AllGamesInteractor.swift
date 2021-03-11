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
    var matchID : String! { get set }
    var heroID : Int? {get set}
    var mode : AllGames.Mode! {get set}
}

class AllGamesInteractor : AllGamesBusinessLogic, AllGamesDataStore{
    var games: [Match] = [Match]()
    var presenter : AllGamesPresentLogic?
    var isLoading = false
    var matchID: String!
    var heroID: Int?
    var mode : AllGames.Mode! = .normal
    var subscription = Set<AnyCancellable>()
    func fetchMore(request: AllGames.Cell.Request) {
//        if !isLoading {
//            isLoading = true
//            OpenDota.shared.get(.matches,params: ["limit":20,"offset":games.count],withType: [Match].self).sink(receiveCompletion: {_ in }, receiveValue: {[unowned self] value in
//                self.games += value
//                self.isLoading = false
//                self.presenter?.presentMoreItems(response: AllGames.Cell.Response(items: value))
//            }).store(in: &subscription)
//        }
        fetch(params: ["limit":20, "offset":games.count]) { value in
            self.games += value
            self.presenter?.presentMoreItems(response: AllGames.Cell.Response(items: value))
        }
    }
    
    func fetch(params : [String:Any],completionHandler: @escaping ([Match])->Void) {
        if !isLoading {
            isLoading = true
            OpenDota.shared.get(.matches,params: params,withType: [Match].self).sink(receiveCompletion: {_ in }, receiveValue: {[unowned self] value in
//                self.games += value
                self.isLoading = false
                completionHandler(value)
//                self.presenter?.presentMoreItems(response: AllGames.Cell.Response(items: value))
            }).store(in: &subscription)
        }
    }
    
    func showItems(request: AllGames.Cell.Request) {
        switch mode {
        case .byHero:
            fetch(params: ["limit":20, "offset":games.count,"hero_id":heroID ?? 93]) { value in
                self.games = value
                self.presenter?.presentItems(response: AllGames.Cell.Response(items: value))
            }
        default:
            presenter!.presentItems(response: AllGames.Cell.Response(items: games) )
        }
        
    }
}
