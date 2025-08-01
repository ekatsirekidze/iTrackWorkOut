//
//  RepeatDaysChoice.swift
//  iTrackWorkOut-1
//
//  Created by X34 on 29.06.25.
//

import SwiftUI

struct RepeatDaysChoice: View {
    @Binding var repeatDays: Set<DayOfWeek>
    
    var body: some View {
        VStack {
            List {
                ForEach(DayOfWeek.all) { dayOfWeek in
                    let dayName = dayOfWeek.string
                    CheckView(
                        isChecked: Binding(
                            get: { repeatDays.contains(dayOfWeek) },
                            set: { newValue in
                                if newValue {
                                    repeatDays.insert(dayOfWeek)
                                } else {
                                    repeatDays.remove(dayOfWeek)
                                }
                            }
                        ),
                        title: "Every \(dayName)"
                    )
                }
            }
        }
    }
}

struct CheckView: View {
    @Binding var isChecked: Bool
    var title: String
    func toggle(){isChecked = !isChecked}
    var body: some View {
        HStack{
            Button(action: toggle) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
            }
            Text(title)
        }
    }
}

