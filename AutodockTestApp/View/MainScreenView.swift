//
//  ViewController.swift
//  AutodockTestApp
//
//  Created by Miron on 13.12.23.
//

import UIKit
import Combine

class MainScreenView: UIViewController {
    
    private var collectionView: UICollectionView!
    private var news: [NewsModel] = []
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Новости"
        
        setupCollectionView()
        fetchData()
    }
    
    
    private func fetchData() {
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
                print(newsResponse)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            })
            .store(in: &cancellables)
    }

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
        
        return news.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCellView.identifier, for: indexPath) as? NewsCellView else {
            return UICollectionViewCell()
        }

        guard indexPath.section < news.count else {
            return cell
        }
        let newsItem = news[indexPath.section]
        
        let viewModel = NewsCellViewModel()
        cell.viewModel.configure(with: newsItem)
        cell.layer.cornerRadius = 10

        cell.backgroundColor = .systemGray6
        return cell
    }
}


