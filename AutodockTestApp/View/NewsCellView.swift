//
//  NewsCellView.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import UIKit
import Combine

class NewsCellView: UICollectionViewCell {
    static let identifier = "NewsCell"
    private var cancellable: AnyCancellable?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true

        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActivityIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(imageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func configure(with newsItem: NewsModel) {
        titleLabel.text = newsItem.title
        imageView.image = UIImage(named: "placeholder")
        activityIndicator.startAnimating()
        
        if let imageUrl = URL(string: newsItem.titleImageUrl) {
            cancellable = URLSession.shared.dataTaskPublisher(for: imageUrl)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.imageView.image = image
                }
        }
    }
}

extension NewsCellView: NewsCellViewModelDelegate {
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}
