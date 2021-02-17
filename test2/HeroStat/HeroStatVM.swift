//
//  HeroStatVM.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import Combine

class HeroStatVM {
    var myStat = CurrentValueSubject<[HeroesStat],Error>([])
    init() {
        myStat.value = Dota.shared.heroesStat.value
    }
    
}
