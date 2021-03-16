//
//  GamePresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

protocol GamePresentLogic {
    func presentGame(response : Game.Cell.Response)
    func initGame(response : Game.Init.Response)
}

class GamePresenter : GamePresentLogic {
    weak var viewController : GameViewLogic?
    
    func presentGame(response: Game.Cell.Response) {
        let game = response.game
        var players = [Game.Cell.ViewModel.Stat]()
        var dire = [Game.Cell.ViewModel.Stat]()
        var radiant = [Game.Cell.ViewModel.Stat]()
        for player in game.players {
            let hero = Dota.shared.heroes.first(where: {$0.id == player.hero_id}) ?? Dota.shared.heroes[91]
            let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
            let kda = String(player.kills ?? 0) + " / " + String(player.deaths ?? 0) + " / " + String(player.assists ?? 0)
//            let kdaPercent = String(((player.kills ?? 0) + (player.assists ?? 0)) / (player.deaths ?? 1) )
            let items = [
                getImageURL(id: player.item_0!),
                getImageURL(id: player.item_1!),
                getImageURL(id: player.item_2!),
                getImageURL(id: player.item_3!),
                getImageURL(id: player.item_4!),
                getImageURL(id: player.item_5!),
            ]
            players.append(
                Game.Cell.ViewModel.Stat(
                    heroImg: heroname + "_full",
                    playerName: player.personaname ?? "Anonymous",
                    kda: kda,
                    kdaPercent: "PERCENT",
                    items: items
                )
            )
            
        }
        dire.append(contentsOf: Array(players.prefix(5)))
        radiant.append(contentsOf: players.suffix(5))
        viewController?.displayGame(
            viewModel: Game.Cell.ViewModel(
                score: [Game.Cell.ViewModel.Score(
                    radiantScore: response.game.radiant_score ?? 0,
                    direScore: response.game.dire_score ?? 0,
                    radiantWin: response.game.radiant_win!),
                    
                ],
                dire: dire,
                radiant: radiant))
    }
    
    func initGame(response: Game.Init.Response) {
        viewController?.initGame(viewModel: Game.Init.ViewModel(matchID: response.matchID))
    }
    
    func getImageURL(id : Int) -> NSURL? {
        let imageURL = Dota.shared.items.first(where: {$0.value.id == id})?.value.img ?? "/Not found"
        return NSURL(string: "https://api.opendota.com" + imageURL)
    }
}
