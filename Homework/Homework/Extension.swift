//
//  Extension.swift
//  Homework
//
//  Created by yulin on 2022/1/17.
//

import Foundation

extension DateFormatter {
    static let rocDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat =  "yyy/MM/dd"
        df.locale = Locale(identifier: "zh_Hant_TW")
        df.timeZone = TimeZone(identifier: "Asia/Taipei")
        df.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        return df
    }()
}
