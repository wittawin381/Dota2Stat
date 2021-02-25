//
//  Dota2.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/2/2564 BE.
//

import Foundation
import Combine
import Alamofire

class Dota {
    static let shared = Dota()
    var heroes = [Hero]()
    let matches = CurrentValueSubject<[Match],AFError>([])
    var heroesStat = CurrentValueSubject<[HeroesStat],AFError>([])
    var record = CurrentValueSubject<[Record],AFError>([])
    var items = [String:Item]()
    var subscription = Set<AnyCancellable>()
    var isLoading : Bool = false
    private init() {
//        OpenDota.shared.get(.matches,params: ["limit":20,"offset":0],withType: [Match].self).sink(receiveCompletion: {_ in }, receiveValue: { value in
//            self.matches.value = value
//        }).store(in: &subscription)
//        OpenDota.shared.get(.heroes,withType: [HeroesStat].self).sink(receiveCompletion: {_ in},receiveValue: { (value) in
//            self.heroesStat.value = value
//        }).store(in: &subscription)
//        
//        OpenDota.shared.get(.record, withType: [Record].self).sink(receiveCompletion: {_ in}, receiveValue: { value in
//            self.record.value = value
//        }).store(in: &subscription)
        
//        var matchDetial : MatchDetail!
//        OpenDota.shared.get("/matches/5840583942", withType: MatchDetail.self).sink(receiveCompletion: { _ in}, receiveValue: { value in
//            matchDetial = value
//            print(matchDetial)
//        }).store(in: &subscription)
        
        heroes = jsonParse(from: "Heroes.json", type: [Hero].self)
        items = jsonParse(from: "Items.json", type: [String : Item].self)
        print(items.first(where: {$0.value.id == 303})?.key)
    }
    
    private func jsonParse<T:Codable>(from path : String, type : T.Type) -> T{
        let name = path.split(separator: ".")
        var data : T!
        if let file = Bundle.main.path(forResource: String(name[0]), ofType: String(name[1])) {
            do {
                let content = try String(contentsOfFile: file)
                data = try! JSONDecoder().decode(type, from: content.data(using: .utf8)!)
            }
            catch {
            }
        }
        else {
            print("FILE NOT FOUND")
        }
        return data
    }
    
    func more() {
        if !isLoading {
            isLoading = true
            OpenDota.shared.get(.matches,params: ["limit":20,"offset":matches.value.count],withType: [Match].self).sink(receiveCompletion: {_ in }, receiveValue: { value in
                self.matches.value += value
                self.isLoading = false
            }).store(in: &subscription)
        }
    }
    
    static let lobbyType : [Int:String] = [
        0:"Normal",
        1:"Practice",
        2:"Tournament",
        3:"Tutorial",
        4:"Coop-Bot",
        5:"Ranked-Team",
        6:"Solo-Ranked",
        7:"Ranked",
        8:"1v1-Mid",
        9:"Battle-Cup"
    ]
    
    static let gameMode: [Int:String] = [
        0:"Unknown",
        1:"All Pick",
        2:"Captain",
        3:"Random Draft",
        4:"Single Draft",
        5:"All Random",
        6:"Intro",
        7:"Dire Tide",
        8:"Reverse Captain",
        9:"Greeviling",
        10:"Tutorial",
        11:"Mid Only",
        12:"Least Player",
        13:"Limited Heroes",
        14:"Compendium",
        15:"Custom",
        16:"Captain Draft",
        17:"Balanced Draft",
        18:"Ability Draft",
        19:"Event",
        20:"Death Match",
        21:"1v1 Mid",
        22:"All Pick",
        23:"Turbo",
        24:"Mutation"
    ]
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

struct Record : Codable, Hashable {
    var field : String?
    var sum : Float?
}

struct MatchDetail : Codable {
    var players : [Player]
}

struct Player : Codable {
    var personaname : String?
    var player_slot : Int?
    var kills : Int?
    var deaths : Int?
    var assits : Int?
}



struct Item : Codable {
    var id : Int?
    var img : String?
}
