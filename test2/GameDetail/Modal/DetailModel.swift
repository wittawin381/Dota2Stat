//
//  DetailModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol PageView {
    
}


enum DetailModal {
    enum UI {
        struct Request{}
        struct Response {
            var playerDetail : Player
        }
        struct ViewModel {
            struct Detail {
                var heroImg : String
                var items : [NSURL?]
                var heroName : String
                var playerName : String
                var kda : String
            }
            struct Page1 : PageView {
                var gpm : String
                var xpm : String
                var damage : String
                var level : String
                var towerDmg : String
                var lastHit : String
                var denies : String
            }
            struct Page2 : PageView {
                var skills : [NSURL?]
            }
            var detail : Detail
            var page1 : Page1
            var page2 : Page2
        }
    }
}
