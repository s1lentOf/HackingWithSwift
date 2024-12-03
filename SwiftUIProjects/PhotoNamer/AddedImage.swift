//
//  AddedImage.swift
//  PhotoNamer
//
//  Created by Ігор Іванченко on 21.11.2024.
//

import Foundation
import SwiftUI

struct AddedImage: Equatable, Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id, name, image
    }

    var id: UUID
    var name: String
    let image: Data

    init(id: UUID, name: String, uiImage: UIImage) {
        self.id = id
        self.name = name
        self.image = uiImage.pngData() ?? Data()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(Data.self, forKey: .image)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(image, forKey: .image)
    }

    var swiftUIImage: Image {
        if let uiImage = UIImage(data: image) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "trash")
        }
    }


    #if DEBUG
    static let example = AddedImage(id: UUID(), name: "My dream car", uiImage: UIImage(resource: .car))
    #endif
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name
    }
}



