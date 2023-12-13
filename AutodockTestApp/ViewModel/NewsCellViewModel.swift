//
//  NewsCellViewController.swift
//  AutodockTestApp
//
//  Created by Anton on 13.12.23.
//


import UIKit
import Combine

class NewsCellViewModel {
    private var cancellable: AnyCancellable?
    private let imageCache = ImageCache.shared
    
    weak var delegate: NewsCellViewModelDelegate?
    
    func configure(with newsItem: NewsModel) {
        delegate?.updateTitle(newsItem.title)
        delegate?.startActivityIndicator()
        
        if let imageUrl = URL(string: newsItem.titleImageUrl) {
            if let cachedImage = imageCache.image(for: imageUrl) {
                delegate?.stopActivityIndicator()
                delegate?.updateImage(cachedImage)
            } else {
                cancellable = URLSession.shared.dataTaskPublisher(for: imageUrl)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: nil)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] image in
                        if let downloadedImage = image {
                            self?.imageCache.saveImage(downloadedImage, for: imageUrl)
                            self?.delegate?.updateImage(downloadedImage)
                        }
                        self?.delegate?.stopActivityIndicator()
                    }
            }
        }
    }
}


