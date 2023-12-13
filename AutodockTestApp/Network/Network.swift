//
//  Network.swift
//  AutodockTestApp
//
//  Created by Anton on 13.12.23.
//

import Foundation
import Combine
import UIKit

class Network {
    static let shared = Network()
    
    private let baseUrl = URL(string: "https://webapi.autodoc.ru/api/news/1/15")!
    
    private init() {}
    
    func fetchNews() -> AnyPublisher<NewsResponse, Error> {
        let requestUrl = baseUrl
        
        return URLSession.shared.dataTaskPublisher(for: requestUrl)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                print("Data is good")
                print(data)
                return data
            }
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchImage(from urlString: String) -> AnyPublisher<UIImage?, Error> {
            guard let imageUrl = URL(string: urlString) else {
                let error = URLError(.badURL)
                return Fail(error: error).eraseToAnyPublisher()
            }

            return URLSession.shared.dataTaskPublisher(for: imageUrl)
                .tryMap { data, response in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.badServerResponse)
                    }
                    return image
                }
                .eraseToAnyPublisher()
        }
}



