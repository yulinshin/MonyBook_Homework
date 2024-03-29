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
                    let cell = TransactionListCellViewObject(name: detail.name, price: detail.price, quantity: detail.quantity)
                    cells.append(cell)
                }
            }
            return .init(title: transaction.title, time: transaction.time, description: transaction.description, cells: cells)
        }.observe(on: MainScheduler.instance)
    }

    func getFormatePrice(price: Int, quantity: Int) -> String {
         let formatter = NumberFormatter()
         formatter.maximumFractionDigits = 0
         formatter.numberStyle = .currency
         let moneyString = formatter.string(from: NSNumber(value: price))
        return "\(moneyString!) x \(quantity)"
     }


    func getFormateDate(dateInt: Int) -> String {
        let date: Date = Date(timeIntervalSince1970: TimeInterval(dateInt) )
         let dateFormatter: DateFormatter = DateFormatter()
         dateFormatter.dateFormat =  "yyy/MM/dd"
         dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
         dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
         dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
         return dateFormatter.string(from: date)
     }
}
