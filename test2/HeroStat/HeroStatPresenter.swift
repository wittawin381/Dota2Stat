//
//  HeroStatPresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol HeroStatPresentLogic {
    func presentItems(response: HeroStat.Cell.Response)
}

class HeroStatPresenter : HeroStatPresentLogic {
    weak var viewController : HeroStatViewLogic?
    
    func presentItems(response: HeroStat.Cell.Response) {
        var returnStat = [HeroStat.Cell.ViewModel.Item]()
        for myStat in response.stats {
            let hero = Dota.shared.heroes.first(where: {$0.id == Int(myStat.hero_id ?? "91")}) ?? Dota.shared.heroes[91]
            let heroname = (hero.name ?? "").lowercased().replacingOccurrences(of: "npc_dota_hero_", with: "")
            
            let winrate = Double(myStat.win ?? 0) * 100.0 /  Double(myStat.games ?? 0)
            returnStat.append(
                HeroStat.Cell.ViewModel.Item(
                    heroImg: heroname + "_full",
                    heroName: hero.localized_name!,
                    matchPlayed: String(myStat.games ?? 0),
                    matchPlayProg: Float(myStat.games ?? 0) / Float(response.stats[0].games ?? 0),
                    winrate: myStat.games == 0 ? "0 %" : String(format: "%.2f %%",winrate),
                    winrateProg: Float(winrate/100)
                )
            )
        }
        
        
        viewController?.displayHeroStat(viewModel: HeroStat.Cell.ViewModel(items: returnStat))
    }
}
