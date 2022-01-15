//
//  TransactionRequest.swift
//  Homework
//
//  Created by yulin on 2022/1/15.
//

import Foundation

struct TransactionRequest: Codable {

    let time: Int
    let title: String
    let description: String
    let details: [TransactionDetail]

    init(time: Int, title: String, description: String, details: [TransactionDetail]) {
        self.time = time
        self.title = title
        self.description = description
        self.details = details
    }

}
