//
//  RecordInteractor.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation
import Combine

protocol RecordBuisinessLogic {
    func fetch(request: Record.Cell.Request)
}

protocol RecordDataStore {
    
}

class RecordInteractor : RecordBuisinessLogic, RecordDataStore {
    var presenter : RecordPresentLogic?
    var subscription = Set<AnyCancellable>()
    
    func fetch(request: Record.Cell.Request) {
        OpenDota.shared.get(.record, withType: [Records].self).sink(receiveCompletion: {_ in}, receiveValue: {[unowned self] value in
            self.presenter?.presentItem(response: Record.Cell.Response(items: value))
        }).store(in: &subscription)
    }
}
