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
    
    private let accountID = "/107373871"
    private let url = "https://api.opendota.com/api"
    static let shared = OpenDota()
    
    enum DataType {
        case matches
        case heroes
        case winlose
        case record
        case peer
    }
    
    func get<T:Codable>(_ type: DataType, params: [String : Any] = [:], withType: T.Type) -> Future<T,Error>{
        
        var geturl : String = ""
        switch type {
        case .matches:
            geturl = url +  "/players" + accountID + "/matches"
        case .heroes:
            geturl = url +  "/players" + accountID + "/heroes"
        case .winlose:
            geturl = url + "/players" + accountID + "/wl"
        case .record:
            geturl = url + "/players" + accountID + "/totals"
        case .peer:
            geturl = url + "/players" + accountID + "/peers"
        }

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
    
    
    func get<T:Codable>(_ type: String, params: [String : Any] = [:], withType: T.Type) -> Future<T,Error>{
        
        let geturl : String = url + type
        
//        let params = ["offset":from]
        
        return Future({promise in
            AF.request(geturl, method: .get, parameters: params, encoding: URLEncoding.queryString).responseString(completionHandler: {response in
                let data = try? JSONDecoder().decode(withType, from: (response.value?.data(using: .utf8))!)
                switch response.result {
                case .failure(let error) :
                    promise(.failure(error))
                case .success:
                    if data != nil {
                        promise(.success(data!))
                    }
                    else {
                        print("Error Fetching data")
                    }
                }
            })
        })
    }
}
