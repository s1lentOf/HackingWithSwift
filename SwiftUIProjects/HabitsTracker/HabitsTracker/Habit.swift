//
//  Habit.swift
//  HabitsTracker
//
//  Created by Ігор Іванченко on 03.10.2024.
//

import Foundation
// Here I'm creating a basic information that each habit has to contain.
// I assign this struct Codable protocol, so that the info can be saved, and Identifiable,
// so that each habit is unique.
struct HabitInfo: Codable, Identifiable {
    var id = UUID()
    let name: String
    let description: String
}


// Here I'm creating a class ('signpoint') for a habits array,
// which contains every habit.
@Observable
class Habits {
    var habits = [HabitInfo]() {
        // Here I'm implementing a function, so that everytime I change, add, or remove value in habits array
        // it is encoded and written to UserDefaults, so that when I close the app,
        // the information would be stored.
        didSet {
            // Trying to encode habits
            if let encoded = try? JSONEncoder().encode(habits) {
                // If value was successfully encoded, it is stored in UserDefaults
                UserDefaults.standard.setValue(encoded, forKey: "Habits")
            }
        }
    }
    
    // here I'm implementing a initializer, so everytime I open the app,
    // it checks if there is any value store in UserDefaults.
    // If so, the value is decoded and assigned to habits array.
    // If no, an empty array is assigned to habits and looks like a fresh app.
    init() {
        // Tries too find the value store in UserDefaults
        if let savedHabits = UserDefaults.standard.data(forKey: "Habits") {
            // If the value is found, it is encoded.
            if let decodeHabits = try? JSONDecoder().decode([HabitInfo].self, from: savedHabits) {
                // And assigned to the habits array
                habits = decodeHabits
                return
            }
        }
        
        
        // If we are still here, an empty array is assigned to the habits.
        habits = []
        return
    }
}
