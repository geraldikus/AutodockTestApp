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
    private var viewModel: MainScreenViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Новости"
        
        viewModel = MainScreenViewModel()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchNews()
    }
    
    private func bindViewModel() {
        viewModel.$news
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
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
    
    private func determineNumberOfColumns() -> Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 2
        } else {
            return 1
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let numberOfColumns = determineNumberOfColumns()
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfColumns)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension MainScreenView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(Double(viewModel.news.count) / Double(numberOfColumns())))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalItems = viewModel.news.count
        let columns = numberOfColumns()
        
        let itemsInSection = section * columns
        
        if itemsInSection + columns <= totalItems {
            return columns
        } else {
            if section == numberOfSections(in: collectionView) - 1 && totalItems % columns != 0 {
                return totalItems % columns
            } else {
                return columns
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCellView.identifier, for: indexPath) as? NewsCellView else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.section * numberOfColumns() + indexPath.row
        guard index < viewModel.news.count else {
            return cell
        }
        
        let newsItem = viewModel.news[index]
        cell.viewModel.configure(with: newsItem)
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * numberOfColumns() + indexPath.row
        guard index < viewModel.news.count else { return }
        let selectedNews = viewModel.news[index]
        
        let detailView = DetailView()
        detailView.fullURLString = selectedNews.fullUrl
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(detailView, animated: false)
    }
    
    
    private func numberOfColumns() -> Int {
        return UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1
    }
}
