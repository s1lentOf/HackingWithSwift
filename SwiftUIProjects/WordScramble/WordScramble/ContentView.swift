//
//  ContentView.swift
//  WordScramble
//
//  Created by Ігор Іванченко on 18.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    @State private var score = 0
    

    var body: some View {
        NavigationStack {
            List {

                Section {
                    HStack {
                        Text ("Score: \(score)")
                    }
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                Section {
                    ForEach (usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName:  "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .toolbar {
                Button ("Change the Word") { restartGame()}
                    .foregroundColor(.blue)
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showAlert) {
                Button("Ok") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    
    
    func addNewWord () {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
             wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word does not exist", message: "You can not just make them up, you know!")
           return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word is not possible", message: "You can not spell that word from \(rootWord).")
            return
        }
        
        guard isPart (word: answer) else {
            wordError(title: "\(answer) is part of \(rootWord)", message: "You can not use word-part from \(rootWord).")
            return
        }
        
        guard isShort (word: answer) else {
            wordError(title: "This word is too short", message: "You can not use \(answer) because it is too short.")
            return
        }
        
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        withAnimation {
            scoreCount()
        }
        
        newWord = ""
    }
    
    func startGame () {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"

                // If we are here everything has worked, so we can exit
                    return
            }
        }
        
        else {
            fatalError("Could not load start.txt form bundle.")
        }
    }
    
    func restartGame() {
        newWord = ""
        usedWords.removeAll()
        startGame()
    }
    
    func isOriginal (word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible (word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
        
    }
    
    func isPart (word: String) -> Bool {
        if rootWord.contains(word) {
            return false
        }
        
        return true
    }
    
    func isShort (word: String) -> Bool {
        if word.count <= 3 {
            return false
        }
        
        return true
    }
    
    func wordError (title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showAlert = true
    }
    
    func scoreCount () {
        if newWord.count == 4 {
            score += 3
        }
        
        else if newWord.count == 5 {
            score += 5
        }
        
        if score >= 15 {
            errorTitle = "You are genius!)"
            errorMessage = "You gained the maximum amount of scores."
            showAlert = true
        }
    }
}

#Preview {
    ContentView()
}
