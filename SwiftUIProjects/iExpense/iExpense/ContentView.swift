import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
    
}

struct SectionView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.title2)
            .foregroundStyle(.brown).bold()
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
        
        return
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    
    @State private var showingAddNew = false
    

    var body: some View {
        NavigationStack {
            
            List {
                
                Section(header: SectionView(text: "Bussiness")) {
                    ForEach(expenses.items.filter { $0.type == "Bussiness" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .foregroundColor(getTextColor(for: item.amount))
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: item.currency))
                                .foregroundStyle(getTextColor(for: item.amount))
                                .padding(5)
                                .background(getBackgroundColor(for: item.amount))
                                .cornerRadius(5)

                        }
                        .swipeActions {
                            NavigationLink {
                                EdittingMode(name: item.name, type: item.type, amount: item.amount, currency: item.currency)
                            } label: {
                                Label("edit", systemImage: "square.and.pencil")
                                    .tint(.blue)
                            }
                            
                            Button {
                                withAnimation (.default){
                                    deleteForm(id: item.id)
                                }
                                
                            } label: {
                                Label("delete", systemImage: "trash.circle")
                                    .tint(.red)

                            }
        
                        }
                    }
                }

                Section (header: SectionView(text: "Personal")) {
                    ForEach (expenses.items.filter { $0.type == "Personal" }) { item in
                        HStack {
                            VStack (alignment: .leading) {
                                Text(item.name)
                                    .foregroundColor(getTextColor(for: item.amount))
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: item.currency))
                                .foregroundColor(getTextColor(for: item.amount))
                                .padding(5)
                                .background(getBackgroundColor(for: item.amount))
                                .cornerRadius(5)

                        }
                        .swipeActions {
                            NavigationLink {
                                EdittingMode(name: item.name, type: item.type, amount: item.amount, currency: item.currency)
                            } label: {
                                Label("edit", systemImage: "square.and.pencil")
                                    .tint(.blue)
                            }
                            
                            Button {
                                withAnimation (.default){
                                    deleteForm(id: item.id)
                                }
                                
                            } label: {
                                Label("delete", systemImage: "trash.circle")
                                    .tint(.red)

                            }
        
                        }
                    }
//                    .onDelete{ offsets in
//                        deleteForm(offsets: offsets, type: "Personal")
//                    }
                    
                }
            }
            
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: expenses)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
                        
        }
    }
    
//    func deleteForm(offsets: IndexSet, type: String) {
//        if type == "Bussiness" {
//            var newExpenses = expenses.items.filter { $0.type == "Bussiness" }
//
//            // Remove from newExpenses based on offsets first
//            newExpenses.remove(atOffsets: offsets)
//
//            // Now remove all items of that type
//            expenses.items.removeAll { $0.type == "Bussiness" }
//
//            // Append the remaining newExpenses back to expenses.items
//            expenses.items.append(contentsOf: newExpenses)
//
//        }
//
//        else if type == "Personal" {
//            var newExpenses = expenses.items.filter { $0.type == "Personal" }
//
//            // Remove from newExpenses based on offsets first
//            newExpenses.remove(atOffsets: offsets)
//
//            // Now remove all items of that type
//            expenses.items.removeAll { $0.type == "Personal" }
//
//            // Append the remaining newExpenses back to expenses.items
//            expenses.items.append(contentsOf: newExpenses)
//        }
//    }
    
    func deleteForm(id: UUID) {
        // Remove the item with the matching id and type
        expenses.items.removeAll { $0.id == id}
    }
    
    func getTextColor(for amount: Double) -> Color {
        switch amount {
        case ...10:
            return .black // Low amount
        case 11...100:
            return .blue // Medium amount
        default:
            return .red // High amount
        }
        
    }

    func getBackgroundColor(for amount: Double) -> Color {
        switch amount {
        case ...10:
            return Color.green.opacity(0.3) // Light green for low amount
        case 11...100:
            return Color.yellow.opacity(0.3) // Light yellow for medium amount
        default:
            return Color.red.opacity(0.2) // Light red for high amount
        }
    }

}

#Preview {
    ContentView()
}
