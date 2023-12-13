//
//  NewsCellViewController.swift
//  AutodockTestApp
//
//  Created by Anton on 13.12.23.
//

import UIKit

protocol NewsCellViewModelDelegate: AnyObject {
    func updateTitle(_ title: String)
}

class NewsCellViewModel {
    weak var delegate: NewsCellViewModelDelegate?
    
    var title: String = "" {
        didSet {
            delegate?.updateTitle(title)
        }
    }
    
    init(title: String) {
        self.title = title
    }
}

