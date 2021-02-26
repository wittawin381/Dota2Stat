//
//  HeroStatModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation

struct HeroesStat : Codable, Hashable {
    var hero_id : String?
    var last_played : Int?
    var games : Int?
    var win : Int?
    var with_games : Int?
    var with_win : Int?
    var against_games : Int?
    var against_win : Int?
}


enum HeroStat {
    enum HeroStatSection : CaseIterable {
        case stat
    }
    enum Cell {
        struct Request {
            
        }
        struct Response {
            var stats : [HeroesStat]
        }
        struct ViewModel {
            struct Item : Hashable{
                var heroImg : String
                var heroName : String
                var matchPlayed : String
                var matchPlayProg : Float
                var winrate : String
                var winrateProg : Float
            }
            var items : [Item]
        }
    }
}
