import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 2
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var idealBedTime = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        
        NavigationStack {
            Form {
                
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please, enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .onChange(of: wakeUp) {
                            calculateBedTime()
                        } // Calls the function when wakeUp changes
                }
                
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) {
                            calculateBedTime()
                        } // Calls the function when sleepAmount changes
                }
                
                Section {
                    Picker("Daily intake coffee:", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { number in
                            Text("\(number)")
                                .foregroundStyle(.primary)
                        }
                    }
                    .font(.headline)
                    .pickerStyle(.menu)
                    .onChange(of: coffeeAmount) {
                        calculateBedTime()
                    } // Calls the function when coffeeAmount changes
                }
            }
            
            VStack {
                Text("Your ideal bedtime is...")
                    .font(.title)
                    .bold()
                Text(idealBedTime)
                    .font(.title)
                    .foregroundColor(.blue)
                    .bold()
            }
            .padding()
            .navigationTitle("BetterRest")
        }
        .onAppear {
            calculateBedTime() // Ensure the calculation happens when the view first appears
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            idealBedTime = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "There was a problem calculating your bedtime"
            showingAlert = true
        }
    }
}

#Preview {
    ContentView()
}
