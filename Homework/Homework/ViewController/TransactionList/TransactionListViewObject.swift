//
//  TransactionListViewObject.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation

struct TransactionListViewObject {
    let sum: Int
    var sections: [TransactionListSectionViewObject]
}

struct TransactionListSectionViewObject {
    let id: Int
    let title: String
    let time: String; #warning("DOTO: format -> 109/10/01")
    var cells: [TransactionListCellViewObject]

    init(id: Int, title: String, time: Int, cells: [TransactionListCellViewObject]) {
        self.id = id
        self.title = title
        let date: Date = Date(timeIntervalSince1970: TimeInterval(time) )
        self.time = DateFormatter.rocDateFormatter.string(from: date)
        self.cells = cells
    }
    
}

struct TransactionListCellViewObject {
    let name: String
    let priceWithQuantity: String; #warning("DOTO: format -> $19,000 x 2")

    init(name: String, price: Int, quantity: Int) {
        self.name = name
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        let moneyString = formatter.string(from: NSNumber(value: price))
       self.priceWithQuantity = "\(moneyString!) x \(quantity)"
    }
}
