//
//  GameInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import Combine

protocol GameBusinessLogic {
    func fetchGame(request: Game.Cell.Request)
    func initGame(request: Game.Init.Request)
}

protocol GameDataStore {
    var games : MatchDetail? { get set }
    var match_id : String! { get set }
}

class GameInteractor : GameBusinessLogic, GameDataStore {
    var presenter : GamePresentLogic?
    private var subscription = Set<AnyCancellable>()
    internal var games: MatchDetail?
    internal var match_id: String!
    

    
    func fetchGame(request: Game.Cell.Request) {
        OpenDota.shared.get("/matches/\(match_id ?? "")", withType: MatchDetail.self).sink(receiveCompletion: {_ in}, receiveValue: {[unowned self] game in
            self.games = game
            self.presenter?.presentGame(response: Game.Cell.Response(game: game))
        }).store(in: &subscription)
    }
        
    
    
    func initGame(request: Game.Init.Request) {
        presenter?.initGame(response: Game.Init.Response(matchID: match_id))
    }
}
