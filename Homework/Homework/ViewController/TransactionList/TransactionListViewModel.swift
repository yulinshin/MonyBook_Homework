//
//  TransactionListViewModel.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import Foundation
import RxSwift

class TransactionListViewModel {

    var disposeBag:DisposeBag = .init()

    @Inject private var apiManager: APIManager
    @Inject private var dbManager: DBManager

    func getTransactionListViewObjects() -> Single<TransactionListViewObject> {
        return apiManager.getTransactions().map { (transactions) -> TransactionListViewObject in

            if DBManager.sharedInstance.createDatabase() {
                DBManager.sharedInstance.insertTransactionData(transactions: transactions)
            }else{
                DBManager.sharedInstance.insertTransactionData(transactions: transactions)
            }

            var sum = 0
            var sections = [TransactionListSectionViewObject]()
            transactions.forEach { transaction in
                var cells = [TransactionListCellViewObject]()
                transaction.details?.forEach({ transactionDetail in
                    let cellViewObject = TransactionListCellViewObject(name: transactionDetail.name, priceWithQuantity: self.getFormatePrice(price: transactionDetail.price, quantity: transactionDetail.quantity))
                    sum += transactionDetail.price * transactionDetail.quantity
                    cells.append(cellViewObject)
                })
                sections.append(TransactionListSectionViewObject(id: transaction.id, title: transaction.title, time: self.getFormateDate(dateInt: transaction.time), cells: cells))

                sections.sort(by: { return $0.time < $1.time })
            }

            return .init(sum: sum, sections: sections)
        }.observe(on: MainScheduler.instance)
    }

    func getTransactionListViewObjectsFromLocal() -> TransactionListViewObject {

        let transactions = dbManager.loadTransactions()
        var sum = 0
        var sections = [TransactionListSectionViewObject]()
        transactions.forEach { transaction in
            var cells = [TransactionListCellViewObject]()
            transaction.details?.forEach({ transactionDetail in
                let cellViewObject = TransactionListCellViewObject(name: transactionDetail.name, priceWithQuantity: getFormatePrice(price: transactionDetail.price, quantity: transactionDetail.quantity))
                sum += transactionDetail.price * transactionDetail.quantity
                cells.append(cellViewObject)
            })
            sections.append(TransactionListSectionViewObject(id: transaction.id, title: transaction.title, time: self.getFormateDate(dateInt: transaction.time), cells: cells))

            sections.sort(by: { return $0.time < $1.time })
        }

        return .init(sum: sum, sections: sections)
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

    func deleteTransaction(id: Int) {
        apiManager.deleteTransactions(id: id).subscribe(onSuccess: { transactions in
            self.dbManager.deleteTransactionData(transactionId: id)
            self.dbManager.deleteTransactionDetailData(transactionId: id)
        }, onFailure: { error in
            print(error)
        }).disposed(by: disposeBag)

    }
}
