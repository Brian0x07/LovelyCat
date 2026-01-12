//
//  CatAPIManager.swift
//  LovelyCat
//
//  Created by xiaolei on 1/12/26.
//

import Foundation

final class CatAPIManager {
    var getData: (Endpoint) async throws -> Data
    
    static let shared = {
        let config = URLSessionConfiguration.default
        var headers = config.httpAdditionalHeaders ?? [:]
        headers["x-api-key"] = MySecret.apiKey
        config.httpAdditionalHeaders = headers
        
        let session = URLSession(configuration: config)
        return CatAPIManager { try await session.data(for: $0.request) }
    }()
    
    static let stub = CatAPIManager { $0.stub }
    
    private init(getData: @escaping (Endpoint) async throws -> Data) {
        self.getData = getData
    }
}

extension CatAPIManager {
    func getImages() async throws -> [ImageResponse] {
        try await fetch(endpoint: .images)
    }
    
    func getFavorites() async throws -> [FavoriteItem] {
        try await fetch(endpoint: .favorites)
    }
    
    func addToFavorite(imageID: String) async throws -> Int {
        let body = ["image_id": imageID]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        let response: FavoriteCreationResponse = try await fetch(endpoint: .addToFavorite(bodyData: bodyData))
        return response.id
    }
    
    func removeFromFavorite(id: Int) async throws {
        _ = try await getData(.removeFromFavorite(id: id))
    }
}

private extension CatAPIManager {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let data = try await getData(endpoint)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: data)
    }
}

extension CatAPIManager {
    struct ImageResponse: Decodable {
        let id: String
        let url: URL
        let width, height: CGFloat
    }
    
    struct FavoriteCreationResponse: Decodable {
        let id: Int
    }
}


extension CatAPIManager {
    enum Endpoint {
        case images
        case addToFavorite(bodyData: Data)
        case favorites
        case removeFromFavorite(id: Int)
        
        var request: URLRequest {
            switch self {
            case .images:
                return URLRequest(url: "https://api.thecatapi.com/v1/images/search?limit=10")
            case .addToFavorite(let bodyData):
                var urlRequest = URLRequest(url: "https://api.thecatapi.com/v1/favourites")
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = bodyData
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                return urlRequest
            case .favorites:
                //TODO: 新增页面参数
                return URLRequest(url: "https://api.thecatapi.com/v1/favourites")
            case .removeFromFavorite(let id):
                var urlRequest = URLRequest(url: URL(string: "https://api.thecatapi.com/v1/favourites/\(id)")!)
                urlRequest.httpMethod = "DELETE"
                return urlRequest
            }
        }
    }
}
