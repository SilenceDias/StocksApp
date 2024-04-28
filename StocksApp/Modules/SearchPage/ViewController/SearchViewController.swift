//
//  SearchViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//


import UIKit

class SearchViewController: UIViewController {
    private let viewModel = SearchViewModel()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            return
        }
        
        viewModel.search(query: query) { [weak self] stocks in
            guard let resultsViewController = self?.searchController.searchResultsController as? SearchResultsViewController else {
                return
            }
            resultsViewController.update(with: stocks)
        }
    }
}

//import UIKit
//import Moya
//
//class SearchViewController: UIViewController {
//    
//    private lazy var searchViewController: UISearchController = {
//        let searchViewController = UISearchController(searchResultsController: SearchResultsViewController())
//        searchViewController.searchBar.placeholder = "Search"
//        searchViewController.searchBar.searchBarStyle = .minimal
//        searchViewController.searchBar.tintColor = .black
//        searchViewController.definesPresentationContext = true
//        searchViewController.searchResultsUpdater = self
//        searchViewController.searchBar.delegate = self
//        return searchViewController
//    }()
//    
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
//            let item = NSCollectionLayoutItem(
//                layoutSize: .init(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .fractionalHeight(1)
//                )
//            )
//            
//            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
//            
//            let group = NSCollectionLayoutGroup.horizontal(
//                layoutSize: .init(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(150)),
//                subitem: item,
//                count: 2
//            )
//            
//            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
//            
//            return NSCollectionLayoutSection(group: group)
//        }
//        
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
////        collection.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
//        collection.delegate = self
//        collection.dataSource = self
//        collection.backgroundColor = .white
//        collection.showsVerticalScrollIndicator = false
//        return collection
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Search"
//        navigationController?.navigationBar.barTintColor = .black
//        navigationItem.searchController = searchViewController
//        searchViewController.searchBar.delegate = self
//        searchViewController.searchResultsUpdater = self
//        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .black
//        
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
//            make.left.right.equalToSuperview()
//        }
//    }
//}
//
//extension SearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard
//            let resultsViewController = searchController.searchResultsController as? SearchResultsViewController,
//            let text = searchController.searchBar.text,
//            !text.trimmingCharacters(in: .whitespaces).isEmpty
//        else {
//            return
//        }
//        
//        let target = StockTarget.symbolLookup(query: text)
//        StockManager.shared.perform(target) { (result: Result<[Stock], APINetworkError>) in
//            switch result {
//            case .success(let stocks):
//                resultsViewController.update(with: stocks)
//            case .failure(let error):
//                break
//            }
//        }
//    }
//}
//
//extension SearchViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.textColor = .black
//    }
//}
//
//extension SearchViewController: UISearchBarDelegate {
//        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            guard
//                let resultsViewController = searchViewController.searchResultsController as? SearchResultsViewController,
//                let query = searchViewController.searchBar.text,
//                !query.trimmingCharacters(in: .whitespaces).isEmpty
//            else {
//                return
//            }
//            
//            let target = StockTarget.symbolLookup(query: query)
//            StockManager.shared.perform(target) { (result: Result<[Stock], APINetworkError>) in
//                switch result {
//                case .success(let tracks):
//                    resultsViewController.update(with: tracks)
//                case .failure(let error):
//                    break
//            }
//        }
//    }
//}
//
//extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//        func numberOfSections(in collectionView: UICollectionView) -> Int {
//            1
//    }
//        
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let resultsViewController = searchViewController.searchResultsController as? SearchResultsViewController else {
//            return 0
//        }
//        return resultsViewController.numberOfRows
//    }
//        
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
//                return UICollectionViewCell()
//        }
//        
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
//}
