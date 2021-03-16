//
//  PeersModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import Foundation



struct Peer : Codable {
    var account_id: Int?
    var with_win: Int?
    var with_games: Int?
    var personaname: String?
    var name: String?
    var avatar: String?
}

enum PeerSection : CaseIterable {
    case peer
}

enum Peers {
    enum Cell {
        struct Request {
            
        }
        struct Response {
            var peers : [Peer]
        }
        struct ViewModel {
            struct PeerItems : Hashable {
                var playerImg : NSURL?
                var playerName : String
                var games : String
                var winWith : String
            }
            var peers : [PeerItems]
        }
    }
}
