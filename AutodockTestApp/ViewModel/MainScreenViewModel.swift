//
//  MainScreenViewModel.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import Foundation
import Combine

class MainScreenViewModel {
    @Published var news: [NewsModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchNews() {
        Network.shared.fetchNews()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching data: \(error)")
                case .finished:
                    print("Data is ok")
                    break
                }
            }, receiveValue: { [weak self] newsResponse in
                self?.news = newsResponse.news
            })
            .store(in: &cancellables)
    }
}

