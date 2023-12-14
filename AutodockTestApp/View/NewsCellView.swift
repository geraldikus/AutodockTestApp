//
//  NewsCellView.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import UIKit

protocol NewsCellViewModelDelegate: AnyObject {
    func updateTitle(_ title: String)
    func updateImage(_ image: UIImage)
    func startActivityIndicator()
    func stopActivityIndicator()
}

class NewsCellView: UICollectionViewCell {
    static let identifier = "NewsCell"
    var viewModel = NewsCellViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = .boldSystemFont(ofSize: 20)
        } else {
            label.font = .boldSystemFont(ofSize: 16)
        }
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActivityIndicator()
        viewModel.delegate = self
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
}

extension NewsCellView: NewsCellViewModelDelegate {
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func updateImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

