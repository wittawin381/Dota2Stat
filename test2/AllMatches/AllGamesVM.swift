//
//  AllGamesVM.swift
//  test2
//
//  Created by Wittawin Muangnoi on 15/2/2564 BE.
//

import Foundation
import Combine

class AllGamesVM {
    let matches = CurrentValueSubject<[Match],Error>([])
    var heroes = [Hero]()
    var heroesStat = CurrentValueSubject<[HeroesStat],Error>([])
    var subscription = Set<AnyCancellable>()
    init() {
        Dota.shared.matches.sink(receiveCompletion: {_ in}, receiveValue: { value in
            self.matches.value = value
        }).store(in: &subscription)
        heroes = Dota.shared.heroes
        heroesStat.value = Dota.shared.heroesStat.value
    }
    
    func loadMoreData() {
        Dota.shared.more()
    }
}
