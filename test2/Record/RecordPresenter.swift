//
//  RecordPresenter.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import Foundation


protocol RecordPresentLogic {
    func presentItem(response: Record.Cell.Response)
}

class RecordPresenter : RecordPresentLogic {
    weak var viewController : RecordViewLogic?
    func presentItem(response: Record.Cell.Response) {
        var records = [Record.Cell.ViewModel.Item]()
        _ = response.items.map({ item in
            let title = item.field!.replacingOccurrences(of: "_", with: " ").capitalized
            let sum = String(format: "%.0f", item.sum!)
            records.append(Record.Cell.ViewModel.Item(title: title , value: sum))
        })
        viewController?.displayRecord(viewModel: Record.Cell.ViewModel(items: records))
    }
}
