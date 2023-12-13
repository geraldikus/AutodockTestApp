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
        
        return viewModel.news.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCellView.identifier, for: indexPath) as? NewsCellView else {
            return UICollectionViewCell()
        }

        guard indexPath.section < viewModel.news.count else {
            return cell
        }
        let newsItem = viewModel.news[indexPath.section]
        
        cell.viewModel.configure(with: newsItem)
        cell.layer.cornerRadius = 10

        cell.backgroundColor = .systemGray6
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section < viewModel.news.count else { return }
        let selectedNews = viewModel.news[indexPath.section]
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.alpha = 0.1
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                cell.alpha = 1.0
            }
            
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
    }

}
