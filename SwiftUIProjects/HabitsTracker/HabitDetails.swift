//
//  HabitDetails.swift
//  HabitsTracker
//
//  Created by Ігор Іванченко on 04.10.2024.
//

import SwiftUI

struct HabitDetails: View {
    let name: String
    let description: String
    
    init(name: String = "", description: String = "") {
        self.name = name
        self.description = description
    }
    
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading){
                Text(description)
            }
        }
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HabitDetails()
}
