//
//  homePresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 22/2/2564 BE.
//

import Foundation


protocol HomePresentationLogic {
    func presentItems(response : Home.TableViewCell.Response)
}

class HomePresenter : HomePresentationLogic {
    weak var viewController: HomeViewLogic?
    func presentItems(response: Home.TableViewCell.Response) {
        let matches = response.matches
        let stats = response.heorStat
        var returnMatches = [DisplayItems]()
        var returnStat = [DisplayItems]()
        _ = matches.map{ match in
            let a = match.player_slot! / 128 == 0
            let b = match.radiant_win!
            let hero = Dota.shared.heroes.first(where: {$0.id == Int(match.hero_id ?? 99)}) ?? Dota.shared.heroes[91]
            let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
            returnMatches.append(
                Home.TableViewCell.ViewModel.MatchCell(
                    matchID : String(match.match_id!),
                    heroImg: heroname + "_full",
                    result: ( a && b || !a && !b ) ? "Won" : "Lost",
                    bracket: Dota.lobbyType[match.lobby_type ?? 0]!,
                    gameMode: Dota.gameMode[match.game_mode ?? 0]!,
                    kda: String(match.kills ?? 0) + " / " + String(match.deaths ?? 0) + " / " + String(match.assists ?? 0)
                )
            )
        }
        _ = stats.map{ myStat in
            let hero = Dota.shared.heroes.first(where: {$0.id == Int(myStat.hero_id ?? "91")}) ?? Dota.shared.heroes[91]
            let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
            
            let winrate = Double(myStat.win ?? 0) * 100.0 /  Double(myStat.games ?? 0)
            returnStat.append(
                Home.TableViewCell.ViewModel.HeroStatCell(
                    heroImg: heroname + "_full",
                    heroName: hero.localized_name!,
                    matchPlayed: String(myStat.games ?? 0),
                    matchPlayProg: Float(myStat.games ?? 0) / Float(stats[0].games ?? 0),
                    winrate: myStat.games == 0 ? "0 %" : String(format: "%.2f %%",winrate),
                    winrateProg: Float(winrate/100)
                )
            )
        }
        viewController?.displayFetched(viewModel: Home.TableViewCell.ViewModel(matches: returnMatches, stats: returnStat))
    }
}
