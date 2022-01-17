//
//  DBManager.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation
import FMDB
import RxSwift

#warning("DOTO: DBManager")

class DBManager: NSObject {

    let field_id = "id"
    let field_transactionId = "transactionId"
    let field_time = "time"
    let field_title = "title"
    let field_description = "description"
    let field_details = "details"
    let field_name = "name"
    let field_quantity = "quantity"
    let field_price = "price"

    static let sharedInstance:DBManager = .init()

    let databaseFileName = "Transaction.sqlite"

    var pathToDatabase: String!

    var database: FMDatabase!

    override init() {
        super.init()

        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }

    func createDatabase() -> Bool {
        var created = false

        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)

            if database != nil {
                // Open the database.
                if database.open() {

                    let createTransactionDetailTableQuery = "create table transactionDetail (\(field_id) text primary key not null, \(field_transactionId) integer not null, \(field_name) text not null, \(field_quantity) integer not null, \(field_price) integer not null)"

                    let createTransactionTableQuery = "create table transactions (\(field_id) integer   primary key not null, \(field_title) text not null, \(field_time) text not null, \(field_description) text not null)"

                    do {
                        try database.executeUpdate(createTransactionDetailTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create transactionDetail table.")
                        print(error.localizedDescription)
                    }

                    do {
                        try database.executeUpdate(createTransactionTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create transactions table.")
                        print(error.localizedDescription)
                    }


                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }

        return created
    }

    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }

        if database != nil {
            if database.open() {
                return true
            }
        }

        return false
    }

    func insertTransactionData(transactions: [Transaction]) {
        if openDatabase() {
            var query = ""
            for transaction in transactions {
                query += "insert or replace into transactions (\(field_id), \(field_title), \(field_time), \(field_description)) values (\(transaction.id), '\(transaction.title)', '\(transaction.time)', '\(transaction.description)');"
                if let transactionDetail = transaction.details {
                    insertTransactionDetailData(transactionId: transaction.id, transactionDetail: transactionDetail)
                }
                }

            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database. data: \(transactions)")
                print(database.lastError(), database.lastErrorMessage())
            }

            database.close()
        }
    }

    func insertTransactionDetailData(transactionId: Int, transactionDetail:[TransactionDetail]) {
        if openDatabase() {
            var query = ""
            for transactionDetail in transactionDetail {

                query += "insert or replace into transactionDetail (\(field_id), \(field_transactionId), \(field_name), \(field_quantity), \(field_price)) values ('\(transactionId)\(transactionDetail.name)', '\(transactionId)', '\(transactionDetail.name)', '\(transactionDetail.quantity)', \(transactionDetail.price));"

            }

            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }

    func loadTransactions() -> [Transaction] {

        var transactions: [Transaction]!

        if openDatabase() {
            let query = "select * from transactions order by \(field_time) asc"

            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)

                while results.next() {

                    let transaction = Transaction(id: Int(results.int(forColumn: field_id)), time: Int(results.int(forColumn: field_time)), title: results.string(forColumn: field_title)!, description: results.string(forColumn: field_description)!, details: loadTransactionDetails(transactionId: Int(results.int(forColumn: field_id))))

                    if transactions == nil {
                        transactions = [Transaction]()
                    }

                    transactions.append(transaction)
                }
            }
            catch {
              print(error)
            }

        }
        if transactions == nil {
            transactions = [Transaction]()
        }
        return transactions
    }

    func loadTransaction(transactionId: Int) -> Single<Transaction> {

        var transaction: Transaction!

        if openDatabase() {
            let query = "select * from transactions where \(field_id)=?"

            do {
                print(database)
                let results = try database.executeQuery(query, values: [transactionId])

                while results.next() {

                    transaction = Transaction(id: Int(results.int(forColumn: field_id)), time: Int(results.int(forColumn: field_time)), title: results.string(forColumn: field_title)!, description: results.string(forColumn: field_description)!, details: loadTransactionDetails(transactionId: transactionId))

                }
            }
            catch {
                return Single.error(error)
            }

        }

        return Single<Transaction>.just(transaction)
    }


    func loadTransactionDetails(transactionId: Int) -> [TransactionDetail]! {

        var transactionDetails: [TransactionDetail]!

        if openDatabase() {
            let query = "select * from transactionDetail where \(field_transactionId)=?"

            do {
                print(database)
                let results = try database.executeQuery(query, values: [transactionId])

                while results.next() {

                    let transactionDetail = TransactionDetail(name: results.string(forColumn: field_name)!, quantity: Int(results.int(forColumn: field_quantity)), price: Int(results.int(forColumn: field_price)))


                    if transactionDetails == nil {
                        transactionDetails = [TransactionDetail]()
                    }

                    transactionDetails.append(transactionDetail)
                }
            }
            catch {
                print(error.localizedDescription)
            }

        }

        return transactionDetails
    }


    func deleteTransactionData(transactionId: Int) {
        if openDatabase() {
            let query = "delete from transactions where \(field_id)=?"

            do {
                try database.executeUpdate(query, values: [transactionId])
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleteTransactionDetailData(transactionId: Int) {
        if openDatabase() {
            let query = "delete from transactionDetail where \(field_transactionId)=?"
            do {
                try database.executeUpdate(query, values: [transactionId])
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

}
