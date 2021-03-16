//
//  GameModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

struct MatchDetail : Codable {
    var dire_score : Int?
    var radiant_score : Int?
    var radiant_win : Bool?
    var players : [Player]
}

struct Player : Codable {
    var personaname : String?
    var player_slot : Int?
    var hero_id : Int?
    var kills : Int?
    var deaths : Int?
    var assists : Int?
    var hero_damage : Int?
    var item_0 : Int?
    var item_1 : Int?
    var item_2 : Int?
    var item_3 : Int?
    var item_4 : Int?
    var item_5 : Int?
    var backpack_0 : Int?
    var backpack_1 : Int?
    var backpack_2 : Int?
    var gold_per_min : Int?
    var xp_per_min : Int?
    var level : Int?
    var tower_damage : Int?
    var last_hits : Int?
    var denies : Int?
    var ability_upgrades_arr : [Int?]
}


enum Game {
    enum GameSection : CaseIterable {
        case score
        case radiant
        case dire
    }
    enum Cell {
        struct Request {
            
        }
        struct Response {
            var game : MatchDetail
        }
        struct ViewModel {
            struct Score : Hashable {
                var radiantScore : Int
                var direScore : Int
                var radiantWin : Bool
            }
            struct Stat : Hashable {
                var heroImg : String
                var playerName : String
                var kda : String
                var kdaPercent : String
                var items: [NSURL?]
            }
            var score : [Score]
            var dire : [Stat]
            var radiant : [Stat]
        }
        
    }
    enum Init {
        struct Request{}
        struct Response {
            var matchID:String
        }
        struct ViewModel {
            var matchID: String
        }
    }
    
//    enum Img {
//        struct Request {
//            
//        }
//        struct Response {
//            
//        }
//        struct ViewModel {
//            
//        }
//    }
}
