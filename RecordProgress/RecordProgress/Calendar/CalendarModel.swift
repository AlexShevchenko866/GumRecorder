//
//  CalendarModel.swift
//  RecordProgress
//
//  Created by admin on 04.03.2026.
//

import Foundation

struct CalendarModel {
    let currentDate: Date
    let selectedMonth: Date
    let isCurrentMonth: Bool
    
    var monthName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Используем локаль из настроек телефона
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: selectedMonth).capitalized
    }
    
    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Используем локаль из настроек телефона
        formatter.calendar = Calendar.current
        
        // Получаем символы дней недели в правильном порядке согласно настройкам пользователя
        let symbols = formatter.shortWeekdaySymbols!
        let firstWeekday = Calendar.current.firstWeekday - 1 // Приводим к индексу массива (0-based)
        
        // Переставляем дни недели согласно настройкам первого дня недели
        let reorderedSymbols = Array(symbols[firstWeekday...]) + Array(symbols[..<firstWeekday])
        
        return reorderedSymbols.map { String($0.prefix(2)).uppercased() }
    }
    
    var daysInMonth: [Date?] {
        let calendar = Calendar.current
        
        // Получаем год и месяц из selectedMonth
        let year = calendar.component(.year, from: selectedMonth)
        let month = calendar.component(.month, from: selectedMonth)
        
        guard let monthRange = calendar.range(of: .day, in: .month, for: selectedMonth) else {
            return []
        }
        
        // Создаем первый день месяца через DateComponents для избежания проблем с часовыми поясами
        var firstDayComponents = DateComponents()
        firstDayComponents.year = year
        firstDayComponents.month = month
        firstDayComponents.day = 1
        firstDayComponents.hour = 12 // Устанавливаем середину дня чтобы избежать проблем с переходами времени
        
        guard let firstOfMonth = calendar.date(from: firstDayComponents) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let calendarFirstWeekday = calendar.firstWeekday
        
        // Рассчитываем количество пустых ячеек в начале месяца
        let emptyCellsCount = (firstWeekday - calendarFirstWeekday + 7) % 7
        
        var days: [Date?] = Array(repeating: nil, count: emptyCellsCount)
        
        // Создаем каждый день через DateComponents
        for day in monthRange {
            var dayComponents = DateComponents()
            dayComponents.year = year
            dayComponents.month = month
            dayComponents.day = day
            dayComponents.hour = 12 // Середина дня
            
            if let date = calendar.date(from: dayComponents) {
                days.append(date)
            }
        }
        
        // Дополняем до полных недель
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: currentDate)
    }
    
    func dayNumber(from date: Date) -> Int {
        Calendar.current.component(.day, from: date)
    }
}
