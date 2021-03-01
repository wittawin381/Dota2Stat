//
//  DetailPresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol DetailPresentLogic {
    func presentPlayerData(response: DetailModal.UI.Response)
}

class DetailPresenter : DetailPresentLogic {
    weak var viewController : DetailModalViewLogic?
    func presentPlayerData(response: DetailModal.UI.Response) {
        let detail = getDetail(response: response)
        let page1 = getPage1(response: response)
        let page2 = getPage2(response: response)
        viewController?.displayPlayerStat(viewModel: DetailModal.UI.ViewModel(detail: detail, page1: page1, page2: page2))
    }
    func getDetail(response: DetailModal.UI.Response) -> DetailModal.UI.ViewModel.Detail {
        let heroImg = Dota.shared.getHeroImage(id: response.playerDetail.hero_id)
        let kda = Dota.shared.getKDA(
            kills: response.playerDetail.kills,
            deaths: response.playerDetail.deaths,
            assists: response.playerDetail.assists
        )
        let heroName = Dota.shared.getHeroName(id: response.playerDetail.hero_id)
        let playerName = response.playerDetail.personaname ?? "Anonymous"
        let items = [
            getImageURL(id: response.playerDetail.item_0!),
            getImageURL(id: response.playerDetail.item_1!),
            getImageURL(id: response.playerDetail.item_2!),
            getImageURL(id: response.playerDetail.item_3!),
            getImageURL(id: response.playerDetail.item_4!),
            getImageURL(id: response.playerDetail.item_5!),
            getImageURL(id: response.playerDetail.backpack_0!),
            getImageURL(id: response.playerDetail.backpack_1!),
            getImageURL(id: response.playerDetail.backpack_2!)
        ]
        return DetailModal.UI.ViewModel.Detail(heroImg: heroImg, items: items,heroName: heroName,playerName: playerName, kda: kda)
    }
    
    func getPage1(response: DetailModal.UI.Response) ->  DetailModal.UI.ViewModel.Page1{
        let gpm = String(response.playerDetail.gold_per_min!)
        let xpm = String(response.playerDetail.xp_per_min!)
        let damage = String(response.playerDetail.hero_damage!)
        let level = String(response.playerDetail.level!)
        let towerDmg = String(response.playerDetail.tower_damage!)
        let lastHit = String(response.playerDetail.last_hits!)
        let denies = String(response.playerDetail.denies!)
        
        return DetailModal.UI.ViewModel.Page1(
            gpm: gpm,
            xpm: xpm,
            damage: damage,
            level: level,
            towerDmg: towerDmg,
            lastHit: lastHit,
            denies: denies
        )
    }
    
    func getPage2(response: DetailModal.UI.Response) -> DetailModal.UI.ViewModel.Page2 {
        var url = [URLS]()
        for item in response.playerDetail.ability_upgrades_arr {
            if let fullurl = Dota.shared.getAbilityImage(id: item!) {
                url.append(URLS(url: NSURL(string: fullurl)))
            }
            else {
                url.append(URLS(url: nil))
            }
        }
        return DetailModal.UI.ViewModel.Page2(skills: url)
        
        
    }
    
    func getImageURL(id : Int) -> NSURL? {
        let imageURL = Dota.shared.items.first(where: {$0.value.id == id})?.value.img ?? "/Not found"
        return NSURL(string: "https://api.opendota.com" + imageURL)
    }
}
