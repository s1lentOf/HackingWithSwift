//
//  AddNewHabit.swift
//  HabitsTracker
//
//  Created by Ігор Іванченко on 03.10.2024.
//

import SwiftUI

struct AddNewHabit: View {
    // Creating an Environment variable, so that I can swipe the Adding sheet.
    @Environment (\.dismiss) var dismiss
    
    // A variable to store habits info.
    var habitsAdd: Habits
    
    // Default property for every textfield.
    @State private var name = ""
    @State private var description = ""
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name:", text: $name)
                TextField("Description:", text: $description)
            }
            .navigationTitle("Add New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    // When I click on the button an item get the info from the textfields.
                    let item = HabitInfo(name: name, description: description)
                    // Then I append this element to the habits array.
                    habitsAdd.habits.append(item)
                    // And close the sheet.
                    dismiss()
                } label: {
                    Image (systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    AddNewHabit(habitsAdd: Habits())
}
