//
//  OpenDota.swift
//  test2
//
//  Created by Wittawin Muangnoi on 13/2/2564 BE.
//

import Foundation
import Alamofire
import Combine

class OpenDota {
    
    private static let accountID = "/107373871"
    private let url = "https://api.opendota.com/api/players" + accountID
    static let shared = OpenDota()
    
    enum DataType {
        case matches
        case heroes
        case winlose
        case record
    }
    
    func get<T:Codable>(_ type: DataType, params: [String : Any] = [:], withType: T.Type) -> Future<T,Error>{
        
        var geturl : String = ""
        switch type {
        case .matches:
            geturl = url +  "/matches"
        case .heroes:
            geturl = url + "/heroes"
        case .winlose:
            geturl = url + "/wl"
        case .record:
            geturl = url + "/totals"
        }
//        let params = ["offset":from]
        
        return Future({promise in
            AF.request(geturl, method: .get, parameters: params, encoding: URLEncoding.queryString).responseString(completionHandler: {response in
                let data = try! JSONDecoder().decode(withType, from: (response.value?.data(using: .utf8))!)
                switch response.result {
                case .failure(let error) :
                    promise(.failure(error))
                case .success:
                    promise(.success(data))
                }
            })
        })
    }
    
//    func getHeroes
}
