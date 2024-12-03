//
//  ContentView.swift
//  PhotoNamer
//
//  Created by Ігор Іванченко on 21.11.2024.
//
import SwiftUI
import CoreLocation
import PhotosUI

struct ContentView: View {
    @State private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.photos.isEmpty {
                    PhotosPicker(selection: $viewModel.selectedImage, matching: .images) {
                        ContentUnavailableView(
                            "No Image",
                            systemImage: "photo.badge.plus",
                            description: Text("Tap to import an image")
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.photos) { photo in
                                NavigationLink {
                                    DetailView(image: photo) { updatedPhoto in
                                        viewModel.editImage(image: updatedPhoto)
                                    }
                                } label: {
                                    VStack(alignment: .center, spacing: 8) {
                                        photo.swiftUIImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxHeight: 200)
                                            .cornerRadius(8)
                                            .padding(.horizontal, 10)

                                        Text(photo.name.isEmpty ? "Untitled" : photo.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .padding(.horizontal, 10)
                                    }
                                    .cornerRadius(12)
                                }
                            }
                            
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .navigationTitle("Image Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $viewModel.selectedImage, matching: .images) {
                        Label("Add Photo", systemImage: "plus")
                    }
                }
            }
            .onChange(of: viewModel.selectedImage) {
                viewModel.loadImage()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
