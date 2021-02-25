////
////  mainVM.swift
////  test2
////
////  Created by Wittawin Muangnoi on 13/2/2564 BE.
////
//
//import Foundation
//import Combine
//
//class HomeVM {
//    var subscription = Set<AnyCancellable>()
//    let matches = CurrentValueSubject<[Match],Error>([])
//    var heroes = [Hero]()
//    var heroesStat = CurrentValueSubject<[HeroesStat],Error>([])
//
//
//    init() {
//        
//        Dota.shared.matches.sink(receiveCompletion: {_ in}, receiveValue: { value in
//            self.matches.value = value
//        }).store(in: &subscription)
//        Dota.shared.heroesStat.sink(receiveCompletion: {_ in},receiveValue: { (value) in
//            self.heroesStat.value = value
//        }).store(in: &subscription)
//
//    }
//
//
//
//
//}
