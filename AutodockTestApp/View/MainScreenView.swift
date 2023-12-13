//
//  ViewController.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import UIKit

class MainScreenView: UIViewController {
    
    private var collectionView: UICollectionView!
//    private let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Новости"
        
        setupCollectionView()
    }

    // В методе setupCollectionView() вашего MainScreenView
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewsCellView.self, forCellWithReuseIdentifier: NewsCellView.identifier)
        view.addSubview(collectionView)
    }


    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        return layout
    }

}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension MainScreenView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCellView.identifier, for: indexPath) as? NewsCellView else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = "Заголовок новости"
        cell.backgroundColor = .green
        
        return cell
    }
}


