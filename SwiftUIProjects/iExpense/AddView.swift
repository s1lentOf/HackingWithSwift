//
//  AddView.swift
//  iExpense
//
//  Created by Ігор Іванченко on 25.09.2024.
//

import SwiftUI

struct AddView: View {
    
    @Environment (\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency = "USD"
    
    let currencies = ["USD", "EUR", "UAH", "GBP", "JPY"]
    
    var expenses: Expenses
    
    let types = ["Bussiness", "Personal"]
    
    var body: some View {
        NavigationStack {
            List {
                
                TextField("Name:" , text: $name)
                
                Picker ("Type", selection: $type) {
                    ForEach (types, id: \.self) {
                        Text($0)
                    }
                }
                
                HStack {
                    
                    TextField("Amount", value: $amount, format: .currency(code: ""))
                        .keyboardType(.decimalPad)
                    
                    Picker("", selection: $currency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                }
                
                
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                Button ("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount, currency: currency)
                    expenses.items.append(item)
                    dismiss()
                    
                }
            }
        }
        
    }
}

#Preview {
    AddView(expenses: Expenses())
}
