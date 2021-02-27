//
//  AllGamesModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation



enum AllGames {
    enum GameSection : CaseIterable {
        case matches
    }
    
    enum Cell {
        struct Request {
            
        }
        struct Response {
            var items : [Match]
        }
        struct ViewModel {
            struct Item : Hashable {
                var matchID : String
                var heroImg : String
                var result : String
                var bracket : String
                var gameMode : String
                var kda : String
            }
            var items : [Item]
        }
    }
}
