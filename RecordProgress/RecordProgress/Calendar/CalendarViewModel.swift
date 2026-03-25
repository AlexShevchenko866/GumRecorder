//
//  CalendarViewModel.swift
//  RecordProgress
//
//  Created by admin on 04.03.2026.
//

import SwiftUI
import Observation
import Combine

@Observable
class CalendarViewModel  {
    var workouts: [Workout] = MockWorkout.shared.workouts
    
    let currentDate = Date()
    var selectedMonth: Date = Date()
    var selectedDay: Date? = Date() // По умолчанию выбран сегодняшний день
    var worckoutForDay: Workout = Workout(exerceses: [], timeStamp: Int(Date().timeIntervalSince1970), date: Date())
    var currentMonthIndex: Int = 25 // Стартуем с середины массива (текущий месяц)
    private var monthsRange = 50 // Начинаем с 50 месяцев
    private var _availableMonths: [Date] = []
    
    var availableMonths: [Date] {
        if _availableMonths.isEmpty {
            generateInitialMonths()
        }
        return _availableMonths
    }
    
    private func generateInitialMonths() {
        _availableMonths = []
        let calendar = Calendar.current
        let startOffset = -25 // 25 месяцев в прошлое
        
        for i in 0..<monthsRange {
            if let month = calendar.date(byAdding: .month, value: startOffset + i, to: currentDate) {
                _availableMonths.append(month)
            }
        }
    }
    
    init() {
        // Инициализируем selectedDay сегодняшним днем с временем 12:00
        let calendar = Calendar.current
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        todayComponents.hour = 12
        selectedDay = calendar.date(from: todayComponents) ?? currentDate
        
        // Убеждаемся что месяцы сгенерированы
        generateInitialMonths()
        // Устанавливаем текущий месяц
        selectedMonth = availableMonths[currentMonthIndex]
    }
    
    var calendarModel: CalendarModel {
        CalendarModel(
            currentDate: currentDate,
            selectedMonth: selectedMonth,
            isCurrentMonth: Calendar.current.isDate(selectedMonth, equalTo: currentDate, toGranularity: .month)
        )
    }
    
    var isCurrentMonth: Bool {
        Calendar.current.isDate(selectedMonth, equalTo: currentDate, toGranularity: .month)
    }
    
    func goToToday() {
        currentMonthIndex = 25 // Возвращаемся к центру (текущий месяц)
        selectedMonth = availableMonths[currentMonthIndex]
        
        // Устанавливаем selectedDay с временем 12:00
        let calendar = Calendar.current
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        todayComponents.hour = 12
        selectedDay = calendar.date(from: todayComponents) ?? currentDate
    }
    
    func setCurrentMonth(index: Int) {
        guard index >= 0 && index < availableMonths.count else { return }
        currentMonthIndex = index
        selectedMonth = availableMonths[index]
        
        // Проверяем нужно ли расширить календарь
        checkAndExpandCalendar()
    }
    
    private func checkAndExpandCalendar() {
        let expandThreshold = 5 // Когда остается 5 месяцев до края
        
        // Если приближаемся к началу
        if currentMonthIndex < expandThreshold {
            expandCalendarBackward()
        }
        
        // Если приближаемся к концу
        if currentMonthIndex > availableMonths.count - expandThreshold {
            expandCalendarForward()
        }
    }
    
    private func expandCalendarBackward() {
        let calendar = Calendar.current
        let monthsToAdd = 12
        var newMonths: [Date] = []
        
        // Добавляем месяцы в начало
        let firstMonth = _availableMonths.first ?? currentDate
        for i in 1...monthsToAdd {
            if let month = calendar.date(byAdding: .month, value: -i, to: firstMonth) {
                newMonths.insert(month, at: 0)
            }
        }
        
        // Обновляем массив и индекс
        _availableMonths = newMonths + _availableMonths
        currentMonthIndex += monthsToAdd // Сдвигаем индекс на количество добавленных месяцев
        monthsRange += monthsToAdd
        
        print("📅 Расширили календарь назад: добавлено \(monthsToAdd) месяцев")
    }
    
    private func expandCalendarForward() {
        let calendar = Calendar.current
        let monthsToAdd = 12
        
        // Добавляем месяцы в конец
        let lastMonth = _availableMonths.last ?? currentDate
        for i in 1...monthsToAdd {
            if let month = calendar.date(byAdding: .month, value: i, to: lastMonth) {
                _availableMonths.append(month)
            }
        }
        
        monthsRange += monthsToAdd
        print("📅 Расширили календарь вперед: добавлено \(monthsToAdd) месяцев")
    }
    
    // Метод для отладки состояния календаря
    func getCalendarInfo() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let firstMonth = _availableMonths.first.map { formatter.string(from: $0) } ?? "nil"
        let lastMonth = _availableMonths.last.map { formatter.string(from: $0) } ?? "nil"
        let currentMonth = formatter.string(from: selectedMonth)
        
        return """
        📅 Календарь: \(firstMonth) → \(lastMonth)
        🎯 Текущий: \(currentMonth) (индекс: \(currentMonthIndex)/\(availableMonths.count))
        📊 Всего месяцев: \(availableMonths.count)
        """
    }
    
    // Новые методы для работы с выбором дня
    func selectDay(_ date: Date) {
        selectedDay = date
        worckoutForDay = workouts.first(where: { Calendar.current.isDate(Date(timeIntervalSince1970: TimeInterval($0.timeStamp)), inSameDayAs: date) }) ?? Workout(exerceses: [], timeStamp: Int(Date().timeIntervalSince1970), date: Date())
        print(worckoutForDay.exerceses.count)
    }
    
    func isDateSelected(_ date: Date) -> Bool {
        guard let selectedDay = selectedDay else { return false }
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: selectedDay)
    }
    
    // Проверка есть ли тренировка в этот день
    func isDateHighlighted(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return workouts.contains { workout in
            // Используем workout.date (Date) для сравнения
            return calendar.isDate(date, inSameDayAs: workout.date)
        }
    }
}
   

final class MockWorkout {
    
    static let shared = MockWorkout()
    
    var workouts: [Workout] = [
        // Тренировка на сегодня
        Workout(
            exerceses: [
                Exercise(
                    id: 1,
                    name: "Жим лёжа",
                    isChoosen: true,
                    sets: [
                        Set(weight: 80, count: 10),
                        Set(weight: 85, count: 8),
                        Set(weight: 90, count: 6)
                    ],
                    doubleWeigth: false,
                    bodyweight: false
                ),
                Exercise(
                    id: 2,
                    name: "Приседания",
                    isChoosen: true,
                    sets: [
                        Set(weight: 100, count: 12),
                        Set(weight: 110, count: 10),
                        Set(weight: 120, count: 8)
                    ],
                    doubleWeigth: false,
                    bodyweight: false
                )
            ],
            comment: "Отличная тренировка!",
            timeStamp: Int(Date().timeIntervalSince1970),
            date: Date()
        ),
        // Тренировка 3 дня назад
        Workout(
            exerceses: [
                Exercise(
                    id: 3,
                    name: "Подтягивания",
                    isChoosen: true,
                    sets: [
                        Set(weight: 0, count: 15),
                        Set(weight: 0, count: 12),
                        Set(weight: 0, count: 10)
                    ],
                    doubleWeigth: false,
                    bodyweight: true
                ),
                Exercise(
                    id: 4,
                    name: "Отжимания",
                    isChoosen: true,
                    sets: [
                        Set(weight: 0, count: 20),
                        Set(weight: 0, count: 18),
                        Set(weight: 0, count: 15)
                    ],
                    doubleWeigth: false,
                    bodyweight: true
                )
            ],
            comment: "Работа с собственным весом",
            timeStamp: Int(Date().addingTimeInterval(-3 * 24 * 60 * 60).timeIntervalSince1970),
            date: Date().addingTimeInterval(-3 * 24 * 60 * 60)
            
        ),
        // Тренировка неделю назад
        Workout(
            exerceses: [
                Exercise(
                    id: 5,
                    name: "Становая тяга",
                    isChoosen: true,
                    sets: [
                        Set(weight: 140, count: 5),
                        Set(weight: 150, count: 3),
                        Set(weight: 160, count: 1)
                    ],
                    doubleWeigth: false,
                    bodyweight: false
                )
            ],
            comment: "Тяжёлая тренировка ног и спины",
            timeStamp: Int(Date().addingTimeInterval(-7 * 24 * 60 * 60).timeIntervalSince1970),
            date: Date().addingTimeInterval(-7 * 24 * 60 * 60)
        ),
        // Тренировка 10 дней назад
        Workout(
            exerceses: [
                Exercise(
                    id: 6,
                    name: "Жим гантелей",
                    isChoosen: true,
                    sets: [
                        Set(weight: 30, count: 12),
                        Set(weight: 32, count: 10),
                        Set(weight: 35, count: 8)
                    ],
                    doubleWeigth: true,
                    bodyweight: false
                ),
                Exercise(
                    id: 7,
                    name: "Планка",
                    isChoosen: true,
                    sets: [
                        Set(weight: 0, count: 60), // count в секундах
                        Set(weight: 0, count: 45),
                        Set(weight: 0, count: 30)
                    ],
                    doubleWeigth: false,
                    bodyweight: true
                )
            ],
            comment: "Комплексная тренировка",
            timeStamp: Int(Date().addingTimeInterval(-10 * 24 * 60 * 60).timeIntervalSince1970),
            date: Date().addingTimeInterval(-10 * 24 * 60 * 60)
        ),
        // Тренировка в следующем месяце для тестирования
        Workout(
            exerceses: [
                Exercise(
                    id: 8,
                    name: "Кардио",
                    isChoosen: true,
                    sets: [
                        Set(weight: 0, count: 30) // 30 минут
                    ],
                    doubleWeigth: false,
                    bodyweight: true
                )
            ],
            comment: "Запланированная кардио сессия",
            timeStamp: Int(Date().addingTimeInterval(35 * 24 * 60 * 60).timeIntervalSince1970),
            date: Date().addingTimeInterval(35 * 24 * 60 * 60)
        )
    ]
}

