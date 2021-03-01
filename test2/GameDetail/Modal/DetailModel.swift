//
//  DetailModel.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol PageView {
    
}

struct URLS : Identifiable , Hashable{
    let id = UUID()
    var url : NSURL?
}


enum DetailModal {
    enum SkillsSection : CaseIterable{
        case skills
    }
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
                var skills : [URLS]
            }
            var detail : Detail
            var page1 : Page1
            var page2 : Page2
        }
    }
}
