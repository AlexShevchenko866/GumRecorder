//
//  Calendar.swift
//  RecordProgress
//
//  Created by admin on 10.03.2026.
//

import Foundation

// Расширения для удобной работы с датами
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.dateInterval(of: .month, for: self)?.start ?? self
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.dateInterval(of: .month, for: self)?.end ?? self
    }
    
    func isInSameMonth(as date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
}
