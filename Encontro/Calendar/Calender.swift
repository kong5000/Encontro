//
//  Calender.swift
//  TearTrack
//
//  Created by k on 2024-02-22.
//

import SwiftUI

struct Calender: View {
    @State var currentDate: Date = Date()
    @State var currentMonth: Int  = 0
    @StateObject var viewModel = CalendarViewModel()

    var body: some View {
        NavigationStack{
            
            VStack(spacing: 35){
                let days: [String] = ["Sun", "Mon","Tue","Wed","Thu","Fri","Sat"]
                
                HStack(spacing: 20){
                    VStack(alignment: .leading, spacing: 10){
                        Text(extraDate()[0])
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(extraDate()[1])
                            .font(.title.bold())
                    }
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    
                    Button {
                        withAnimation{
                            currentMonth += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 0){
                    ForEach(days, id:\.self){ day in
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 15){
                    ForEach(extractDate()){value in
                            CardView(value: value)
                        
                    }
                }
            }
            .onChange(of: currentMonth){newValue in
                currentDate = getCurrentMonth()
            }
        }
        
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View{
        NavigationLink {
            if let entry = viewModel.entries.first(where: { entry in
                return isSameDate(date1: entry.date, date2: value.date)
            }){
                Text("DETAIL VIEW")
            }
            else{
                Text("Add view")
            }
        } label: {
            VStack{
                if(value.day != -1){
                    
                    if let entry = viewModel.entries.first(where: { entry in
                        
                        return isSameDate(date1: entry.date, date2: value.date)
                    }){
                        Text("\(value.day)")
                            .font(.title3.bold())
                        Spacer()
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                    }
                    else{
                        Text("\(value.day)")
                            .font(.title3.bold())
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 8)
            .frame(height:60, alignment: .top)
        }
    }
    
    func isSameDate(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        return(date.components(separatedBy: " "))
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day:day, date:date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

extension Date{
    func getAllDates() -> [Date]{
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to:startDate)!
        }
    }
}

struct CalenderPreview: PreviewProvider {
    static var previews: some View {
        let previewViewModel = CalendarViewModel()
        Calender()
            .environmentObject(previewViewModel)
    }
}

