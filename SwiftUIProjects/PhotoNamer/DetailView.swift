//
//  DetailView.swift
//  PhotoNamer
//
//  Created by Ігор Іванченко on 21.11.2024.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
        
    @State private var name = ""
    
    var image: AddedImage
    
    var onSave: (AddedImage) -> Void
    
    init(image: AddedImage, onSave: @escaping (AddedImage) -> Void) {
        self.image = image
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            VStack {
                image.swiftUIImage
                    .resizable()
                    .scaledToFit()
                Form {
                    TextField("Enter the name for this picture", text: $name)
                }
            }
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button("Save") {
                            var newImage = image
                            newImage.id = image.id
                            newImage.name = name
                            
                            onSave(newImage)
                            dismiss()
                        }
                        .disabled(name.isEmpty)
                    }
                }
                
                
            }
        }
        .onAppear {
            name = image.name
        }
    }
}

#Preview {
    DetailView(image: AddedImage.example) { _ in }
}
