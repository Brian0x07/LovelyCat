//
//  FavoriteItem.swift
//  LovelyCat
//
//  Created by xiaolei on 1/12/26.
//

import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    let apiManager = CatAPIManager.shared
    
    @Published private(set) var favorites = [FavoriteItem]()

    func setFavorites(_ favorites: [FavoriteItem]) {
        self.favorites = favorites
    }
    
    func getFavorites() async throws {
        self.favorites = try await apiManager.getFavorites()
    }
    
    func add(_ cat: CatImageViewModel) async throws {
        let id = try await apiManager.addToFavorite(imageID: cat.id)
        self.favorites.append(.init(catImage: cat, id: id))
    }
    
    func remove(at index: Int) async throws {
        try await apiManager.removeFromFavorite(id: self.favorites[index].id)
        self.favorites.remove(at: index)
    }
    
}

struct FavoriteItem: Decodable {
    let id: Int
    let imageID: String
    let createdAt: Date
    let imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case imageID = "image_id"
        case createdAt = "created_at"
        case image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container[.id]
        self.imageID = try container[.imageID]
        self.createdAt = try container[.createdAt]
        
        let imageContainer = try container.nestedContainer(key: .image)
        self.imageURL = try imageContainer["url"]
    }
    
    init(catImage: CatImageViewModel, id: Int) {
        self.id = id
        self.imageID = catImage.id
        self.createdAt = .now
        self.imageURL = catImage.url
    }
}

extension FavoriteItem: Equatable { }
