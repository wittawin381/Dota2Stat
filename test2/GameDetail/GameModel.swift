//
//  GameModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

struct MatchDetail : Codable {
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
}


enum Game {
    enum GameSection : CaseIterable {
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
            struct About : Hashable {
                
            }
            struct Stat : Hashable {
                var heroImg : String
                var playerName : String
                var kda : String
                var kdaPercent : String
                var items: [NSURL?]
            }
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
