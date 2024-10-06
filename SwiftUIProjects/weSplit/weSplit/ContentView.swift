//
//  ContentView.swift
//  weSplit
//
//  Created by Ігор Іванченко on 13.06.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit = "Celsius"
    @State private var outputUnit = "Fahrenheit"
    @State private var inputValue = ""
    @State private var outputValue = ""

    let units = ["Celsius", "Fahrenheit", "Kelvin"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Input Unit")) {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Output Unit")) {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Input Value")) {
                    TextField("Enter value", text: $inputValue)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section {
                    Button(action: convert) {
                        Text("Convert")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                Section(header: Text("Output Value")) {
                    Text("\(outputValue)")
                        .font(.title)
                }
            }
            .navigationTitle("Temperature Converter")
        }
    }

    func convert() {
        guard let input = Double(inputValue) else {
            outputValue = "Invalid input"
            return
        }

        let convertedValue: Double

        if inputUnit == outputUnit {
            convertedValue = input
        } else if inputUnit == "Celsius" && outputUnit == "Fahrenheit" {
            convertedValue = (input * 9 / 5) + 32
        } else if inputUnit == "Celsius" && outputUnit == "Kelvin" {
            convertedValue = input + 273.15
        } else if inputUnit == "Fahrenheit" && outputUnit == "Celsius" {
            convertedValue = (input - 32) * 5 / 9
        } else if inputUnit == "Fahrenheit" && outputUnit == "Kelvin" {
            convertedValue = (input - 32) * 5 / 9 + 273.15
        } else if inputUnit == "Kelvin" && outputUnit == "Celsius" {
            convertedValue = input - 273.15
        } else if inputUnit == "Kelvin" && outputUnit == "Fahrenheit" {
            convertedValue = (input - 273.15) * 9 / 5 + 32
        } else {
            outputValue = "Conversion not supported"
            return
        }

        outputValue = String(format: "%.2f", convertedValue)
    }
}

#Preview {
    ContentView()
}
