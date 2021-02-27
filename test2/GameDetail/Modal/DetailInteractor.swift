//
//  DetailInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation

protocol DetailBusinessLogic {
    
}

protocol DetailDataStore {
    
}

class DetailInteractor : DetailBusinessLogic, DetailDataStore {
    var presenter : DetailPresentLogic?
}
