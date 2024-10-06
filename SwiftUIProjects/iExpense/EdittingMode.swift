import SwiftUI

struct EdittingMode: View {
    @Environment (\.dismiss) var dismiss
    var name: String
    var type: String
    var amount: Double
    var currency: String
    
    @State private var title: String
    
    init(name: String, type: String, amount: Double, currency: String) {
        self.name = name
        self.type = type
        self.amount = amount
        self.currency = currency
        _title = State(initialValue: name)
    }

    var body: some View {
        List {
            NavigationStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(type)
                    }
                    Spacer()
                    Text(amount, format: .currency(code: currency))
                        .padding(5)
                        .cornerRadius(5)
                }
            }
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button ("Save") {
//                    let item = ExpenseItem(name: title, type: type, amount: amount, currency: currency)
//                    expenses.items.append(item)
                    dismiss()
                    
                }
            }
        }
    }
    

}
