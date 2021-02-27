//
//  AllGamesPresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation

protocol AllGamesPresentLogic {
    func presentItems(response : AllGames.Cell.Response)
    func presentMoreItems(response : AllGames.Cell.Response)
}

class AllGamesPresenter : AllGamesPresentLogic {
    weak var viewController : AllGamesViewLogic?
    
    func presentItems(response: AllGames.Cell.Response) {
        let presentItem = format(response: response)
        viewController?.displayItem(viewModel: AllGames.Cell.ViewModel(items: presentItem))
    }
    
    func presentMoreItems(response: AllGames.Cell.Response) {
        let presentItem = format(response: response)
        viewController?.displayFetchedItem(viewModel: AllGames.Cell.ViewModel(items: presentItem))
    }
    
    func format(response : AllGames.Cell.Response) -> [AllGames.Cell.ViewModel.Item] {
        let items = response.items
        var presentItem = [AllGames.Cell.ViewModel.Item]()
        for item in items {
            let match = item
            let a = match.player_slot! / 128 == 0
            let b = match.radiant_win!
            let hero = Dota.shared.heroes.first(where: {$0.id == Int(match.hero_id ?? 99)}) ?? Dota.shared.heroes[91]
            let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
            presentItem.append(AllGames.Cell.ViewModel.Item(
                            matchID: String(item.match_id!),
                            heroImg: heroname + "_full",
                            result: ( a && b || !a && !b ) ? "Won" : "Lost",
                            bracket: Dota.lobbyType[match.lobby_type ?? 0]!,
                            gameMode: Dota.gameMode[match.game_mode ?? 0]!,
                            kda: String(match.kills ?? 0) + " / " + String(match.deaths ?? 0) + " / " + String(match.assists ?? 0))
            )
        }
        return presentItem
    }
}
