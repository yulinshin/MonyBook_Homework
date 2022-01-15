//
//  InsertTransactionViewModel.swift
//  Homework
//
//  Created by yulin on 2022/1/15.
//

import Foundation
import RxSwift
import RxRelay

class InsertTransactionViewModel {

    let time: Observable<String>
    let title: Observable<String>
    let transactionDescription: Observable<String>
    let details: Observable<[TransactionListCellViewObject]>
    let sections = Section.allCases

    let detailsRelay = BehaviorRelay<[TransactionDetail]>(value: [])
    let timeRelay = BehaviorRelay<String>(value: "")
    let titleRelay = BehaviorRelay<String>(value: "")
    let descriptionRelay = BehaviorRelay<String>(value: "")



    enum Section: CaseIterable {

        case time
        case title
        case transactionDescription
        case details
        case addDetails

        var title: String {
            switch self {

            case .time:
                return "time"

            case .title:
                return "title"

            case .transactionDescription:
                return "transactionDescription"

            case .details:
                return "details"

            case .addDetails:
                return "addDetails"

            }
        }
    }

    var disposeBag:DisposeBag = .init()

    init() {
        details = detailsRelay.asObservable().map({ details in
 var viewObjects = [TransactionListCellViewObject]()
            details.forEach { detail in
                viewObjects.append(TransactionListCellViewObject(name: detail.name, priceWithQuantity: "\(detail.price) & \(detail.quantity)"))
            }
            return viewObjects
        })
        time = timeRelay.asObservable()
        title = titleRelay.asObservable()
        transactionDescription = descriptionRelay.asObservable()
    }

    func addTransactionDetail(name: String, quantity: Int, price: Int){
        let detail = TransactionDetail(name: name, quantity: quantity, price: price)
        self.detailsRelay.accept(detailsRelay.value + [detail])
    }

    func saveTransaction() {

        print ( packObjectToData())

    }

    private func packObjectToData() -> TransactionRequest {
        let dfmatter = DateFormatter()
        dfmatter.dateStyle = .medium
        let date = dfmatter.date(from: timeRelay.value)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateInt:Int = Int(dateStamp)

        let transactionRequest = TransactionRequest(time: dateInt, title: titleRelay.value, description: descriptionRelay.value, details: detailsRelay.value)
        return transactionRequest
    }

}
