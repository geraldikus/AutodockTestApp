//
//  DetailView.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import UIKit
import WebKit

class DetailView: UIViewController {
    
    private let webView = WKWebView()
    
    var fullURLString: String = "" {
        didSet {
            if let url = URL(string: fullURLString) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

