//
//  RecordModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation

struct Records : Codable, Hashable {
    var field : String?
    var sum : Float?
}


enum Record {
    enum RecordSection : CaseIterable {
        case record
    }
    enum Cell {
        struct Request {
            
        }
        struct Response {
            var items : [Records]
        }
        struct ViewModel {
            struct Item : Hashable {
                var title : String
                var value : String
            }
            var items : [Item]
        }
    }
}
