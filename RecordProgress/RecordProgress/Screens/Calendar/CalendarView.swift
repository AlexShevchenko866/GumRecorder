//
//  CalendarView.swift
//  RecordProgress
//
//  Created by admin on 04.03.2026.
//

import SwiftUI
import SwiftfulRouting

struct CalendarView: View {
    @State var vm: CalendarViewModel = CalendarViewModel()
    var router: AnyRouter
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок с Today/Месяц и кнопкой возврата
            headerView
            
            // Дни недели
            weekdaysView
            
            // Горизонтальный скролл с нативной пагинацией
            TabView(selection: Binding(
                get: { vm.currentMonthIndex },
                set: { newIndex in vm.setCurrentMonth(index: newIndex) }
            )) {
                ForEach(Array(vm.availableMonths.enumerated()), id: \.offset) { index, month in
                    monthView(for: month)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                // Убираем индикаторы страниц
                UIPageControl.appearance().isHidden = true
            }
            .frame(height: 280) // Фиксированная высота для календаря
            Spacer()
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(vm.worckoutForDay.exerceses) { exercise in
                        ExerciseView(exercise: exercise)
                    }
                }
            }
            
            Spacer()
            Button("+", action: {
                router.showScreen(.fullScreenCover) { router in
                    AddExerciseView(router: router)
                }
            })
            .frame(width: 100, height: 50, alignment: .center)
            .background(Color.blue)
            .tint(Color.white)
            .font(Font.system(size: 50, weight: .light))
            .cornerRadius(25)
        }
        .padding()
    }
    
    private var headerView: some View {
        HStack {
            Group {
                if vm.isCurrentMonth {
                    Text("calendar.today")
                        .font(.title2)
                        .fontWeight(.bold)
                } else {
                    Text(vm.calendarModel.monthName)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: vm.isCurrentMonth)
            
            Spacer()
            
            if !vm.isCurrentMonth {
                Button(action: {
                    vm.goToToday()
                }) {
                    Text("calendar.today")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.bottom, 16)
        .animation(.easeInOut(duration: 0.3), value: vm.isCurrentMonth)
    }
    
    private var weekdaysView: some View {
        HStack {
            ForEach(vm.calendarModel.weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 8)
    }
    
    private func monthView(for month: Date) -> some View {
        let monthModel = CalendarModel(
            currentDate: vm.currentDate,
            selectedMonth: month,
            isCurrentMonth: Calendar.current.isDate(month, equalTo: vm.currentDate, toGranularity: .month)
        )
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(Array(monthModel.daysInMonth.enumerated()), id: \.offset) { index, date in
                if let date = date {
                    dayView(date: date, monthModel: monthModel)
                } else {
                    Color.clear
                        .frame(height: 40)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func dayView(date: Date, monthModel: CalendarModel) -> some View {
        let isToday = monthModel.isToday(date)
        let isSelected = vm.isDateSelected(date)
        let isHighlighted = vm.isDateHighlighted(date)
        
        return VStack {
            Text("\(monthModel.dayNumber(from: date))")
                .font(.body)
                .fontWeight(isToday || isSelected ? .bold : .regular) // Сегодня и выбранный день жирным
                .foregroundColor(dayTextColor(isToday: isToday, isSelected: isSelected))
        }
        .frame(width: 40, height: 40)
        .background(dayBackground(isToday: isToday, isSelected: isSelected))
        .overlay(
            // Круглая рамка для дат с тренировками
            Circle()
                .stroke(Color.orange, lineWidth: 2)
                .opacity(isHighlighted ? 1 : 0)
        )
        .onTapGesture {
            vm.selectDay(date)
        }
    }
    
    private func dayTextColor(isToday: Bool, isSelected: Bool) -> Color {
        if isToday {
            return .red // Сегодня красными цифрами
        } else if isSelected {
            return .white // Выбранный день белыми цифрами
        }
        return .primary // Остальные дни обычным цветом
    }
    
    private func dayBackground(isToday: Bool, isSelected: Bool) -> some View {
        Circle()
            .fill(backgroundFillColor(isToday: isToday, isSelected: isSelected))
    }
    
    private func backgroundFillColor(isToday: Bool, isSelected: Bool) -> Color {
        if isSelected {
            return .green // Только выбранный день зеленым фоном
        }
        return .clear // Сегодня и остальные дни без фона
    }
}


#Preview {
    RouterView { router in
        CalendarView(router: router)
    }
}
