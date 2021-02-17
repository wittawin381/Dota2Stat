//
//  mainModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 13/2/2564 BE.
//

import Foundation


struct Match : Codable, Hashable, Identifiable {
    let id = UUID()
    var match_id : Int?
    var player_slot : Int?
    var radiant_win : Bool?
    var duration : Int?
    var game_mode : Int?
    var lobby_type : Int?
    var hero_id : Int?
    var start_time : Int?
    var version : Int?
    var kills : Int?
    var deaths : Int?
    var assists : Int?
    var skill : Int?
    var party_size : Int?
}

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



struct Hero : Codable {
    var id : Int?
    var name : String?
    var localized_name : String?
    var primary_attr : String?
    var attack_type : String?
    var roles : [String]?
    var legs : Int?
}

enum MatchSection : CaseIterable {
    case matches
    case heroes
}

