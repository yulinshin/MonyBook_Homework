//
//  TransactionDetailViewObject.swift
//  Homework
//
//  Created by yulin on 2022/1/8.
//

import Foundation

struct TransactionDetailViewObject {
    let title: String
    let time: String
    let description: String
    let cells: [TransactionListCellViewObject]


    init(title: String, time: Int, description: String, cells: [TransactionListCellViewObject]) {
        self.title = title
        let date: Date = Date(timeIntervalSince1970: TimeInterval(time) )
        self.time = DateFormatter.rocDateFormatter.string(from: date)
        self.description = description
        self.cells = cells
    }
}
