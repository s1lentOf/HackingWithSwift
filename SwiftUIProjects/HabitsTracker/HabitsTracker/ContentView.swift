//
//  ContentView.swift
//  HabitsTracker
//
//  Created by Ігор Іванченко on 03.10.2024.
//

import SwiftUI


struct ContentView: View {
    
    // I create a variable to store every element of the Habits class,
    // which has habits array.
    @State private var habitsMain = Habits()
    @State private var isShowingAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (habitsMain.habits) { item in
                    NavigationLink {
                        HabitDetails(name: item.name, description: item.description)
                    } label: {
                        VStack (alignment: .leading) {
                            Text(item.name)
                                .font(.title2.bold())
                        }
                    }
                }
                // If I swipe any element, deleteHabit function is called.
                .onDelete(perform: { indexSet in
                    deleteHabit(offsets: indexSet)
                })
            }
            .navigationTitle("Habits Tracker")
            .toolbar {
                Button {
                    // When isShowing turn true, the sheet appears.
                    isShowingAdd = true
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .sheet(isPresented: $isShowingAdd, content: {
                // I send all information of the habits to the AddNewHabbit sheet
                // so that I can get an Info that has to be provided for every element.
                AddNewHabit(habitsAdd: habitsMain)
            })
        }
        
    }
    
    // This function delete the element, that was swapped.
    func deleteHabit (offsets: IndexSet){
        habitsMain.habits.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
