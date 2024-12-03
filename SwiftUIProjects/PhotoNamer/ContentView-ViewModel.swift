//
//  ContentView-ViewModel.swift
//  PhotoNamer
//
//  Created by Ігор Іванченко on 02.12.2024.
//

import Foundation
import CoreLocation
import PhotosUI
import _PhotosUI_SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var photos: [AddedImage]
        var selectedImage: PhotosPickerItem? = nil
        
        let savePath = URL.documentsDirectory.appending(path: "SavedImages")
        
        // An initializer to download images from stored place
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                photos = try JSONDecoder().decode([AddedImage].self, from: data)
            } catch {
                photos = []
            }
        }
        
        // A function to encode images and store them in the local directory
        func saveImages() {
            do {
                let data = try JSONEncoder().encode(photos)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save locations.")
            }
        }
        
        // A function to load image
        func loadImage() {
            Task {
                guard let importedImageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
                guard let inputImage = UIImage(data: importedImageData) else { return }
                
                let currentImage = AddedImage(id: UUID(), name: "", uiImage: inputImage)
                photos.append(currentImage)
                saveImages()
            }
        }
        
        func editImage(image: AddedImage) {
            if let index = photos.firstIndex(where: { $0.id == image.id }) {
                photos[index] = image
                saveImages()
            }
        }
        
        func deleteImage (id: UUID) {
            if let index = photos.firstIndex(where: { $0.id == id }) {
                print("deleted")
                photos.remove(at: index)
                saveImages()
            }
        }
    }
}
