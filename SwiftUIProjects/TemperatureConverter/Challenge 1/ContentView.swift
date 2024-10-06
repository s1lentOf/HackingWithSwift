import SwiftUI

struct ContentView: View {
    @State private var inputUnit = "Celsius"
    @State private var outputUnit = "Fahrenheit"
    @State private var inputValue = ""
    @State private var outputValue = ""

    let units = ["Celsius", "Fahrenheit", "Kelvin"]

    var body: some View {
        VStack {
            Text("Temperature Converter")
                .font(.largeTitle)
                .padding()

            Picker("Input Unit", selection: $inputUnit) {
                ForEach(units, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Picker("Output Unit", selection: $outputUnit) {
                ForEach(units, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            TextField("Enter value", text: $inputValue)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                convert()
                // Dismiss keyboard
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Text("Convert")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Just use Text instead of Section here
            Text("Here is the converted number:")
                .padding(.top)
            
            Text(outputValue)
                .font(.title)
                .padding()

        }
        .padding()
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
