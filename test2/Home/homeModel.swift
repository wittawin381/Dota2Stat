//
//  mainModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 13/2/2564 BE.
//

import Foundation


protocol DisplayItems {
    
}



struct Match : Codable, Hashable {
//    let id : UUID
    var match_id : Int?
    var player_slot : Int?
    var radiant_win : Bool?
    var duration : Int?
    var game_mode : Int?
    var lobby_type : Int?
    var hero_id : Int?
    var start_time : Int?
    var kills : Int?
    var deaths : Int?
    var assists : Int?
    var skill : Int?
    var party_size : Int?
//    init(from decoder: Decoder) throws {
//        id = UUID()
//    }
}

enum Home {
    enum HomeSection : CaseIterable {
        case matches
        case heroes
    }
    
    enum TableViewCell {
        struct Request {
            
        }
        struct Response {
            var matches : [Match]
            var heorStat : [HeroesStat]
        }
        struct ViewModel {
            struct MatchCell : DisplayItems, Hashable{
                var heroImg : String
                var result : String
                var bracket : String
                var gameMode : String
                var kda : String
            }
            struct HeroStatCell : DisplayItems , Hashable{
                var heroImg : String
                var heroName : String
                var matchPlayed : String
                var matchPlayProg : Float
                var winrate : String
                var winrateProg : Float
            }
            var matches : [DisplayItems]
            var stats : [DisplayItems]
        }
    }
}
