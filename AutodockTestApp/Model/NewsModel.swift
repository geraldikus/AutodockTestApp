//
//  NewsModel.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import Foundation

struct NewsModel: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}

struct NewsResponse: Codable {
    let news: [NewsModel]
    let totalCount: Int
}
