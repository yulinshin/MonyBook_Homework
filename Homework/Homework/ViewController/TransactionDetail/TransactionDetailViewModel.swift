//
//  TransactionDetailViewModel.swift
//  Homework
//
//  Created by yulin on 2022/1/9.
//

import Foundation
import RxSwift

class TransactionDetailViewModel {

    var disposeBag:DisposeBag = .init()
    var transactionId: Int

    @Inject private var dbManager: DBManager

    init(transactionId: Int){
        self.transactionId = transactionId
    }

    func getTransactionDetailViewObject() -> Single<TransactionDetailViewObject> {
        return dbManager.loadTransaction(transactionId: self.transactionId).map { (transaction) -> TransactionDetailViewObject in
            var cells = [TransactionListCellViewObject]()
            if let details = transaction.details {
                details.forEach { detail in
                    let cell = TransactionListCellViewObject(name: detail.name, priceWithQuantity: "\(detail.price), \(detail.quantity)")
                    cells.append(cell)
                }
            }
            return .init(title: transaction.title, time: "\(transaction.time)", description: transaction.description, cells: cells)
        }.observe(on: MainScheduler.instance)
    }
}
