//
//  DetailInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol DetailBusinessLogic {
    func getPlayerData(request: DetailModal.UI.Request)
}

protocol DetailDataStore {
    var detail : Player? { get set }
}

class DetailInteractor : DetailBusinessLogic, DetailDataStore {
    var detail: Player?
    var presenter : DetailPresentLogic?
    
    func getPlayerData(request: DetailModal.UI.Request) {
        presenter!.presentPlayerData(response: DetailModal.UI.Response(playerDetail: detail!))
    }
}
