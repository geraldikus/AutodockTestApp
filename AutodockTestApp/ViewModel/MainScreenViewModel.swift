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
                let sortedNews = newsResponse.news.sorted(by: { (news1, news2) -> Bool in
                    if let date1 = self?.getDate(from: news1.publishedDate),
                       let date2 = self?.getDate(from: news2.publishedDate) {
                        return date1 > date2
                    }
                    return false
                })
                self?.news = sortedNews
            })
            .store(in: &cancellables)
    }
    
    private func getDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}


