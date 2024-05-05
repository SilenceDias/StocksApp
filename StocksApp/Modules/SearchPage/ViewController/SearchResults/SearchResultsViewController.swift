//
//  SearchResultsViewController.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import UIKit
import CoreData
import SkeletonView

protocol SearchTableDelegate {
    func passSelectedValue(selected stock: StocksDataModel)
}

class SearchResultsViewController: UIViewController {
    private var searchResults: [StocksDataModel] = []
    private var favoriteStocks: [NSManagedObject] = []
    var favoritesViewModel: FavoritesViewModel?
    var delegate: SearchTableDelegate!

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "StocksTableViewCell")
        tableView.isSkeletonable = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .white
        setupViewModelFavorites()
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func update(with stocks: [StocksDataModel]) {
        self.searchResults = stocks
        tableView.reloadData()
        tableView.isHidden = stocks.isEmpty
    }
    
    private func setupViewModelFavorites(){
        favoritesViewModel = FavoritesViewModel()
        favoritesViewModel?.fetchData()
        favoriteStocks = favoritesViewModel?.getFavorites() ?? [NSManagedObject]()
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as! StocksTableViewCell
        let stockGroup = searchResults[indexPath.row]
        cell.configure(data: stockGroup)
        
        let isFavoriteStock = favoriteStocks.contains { 
            ($0.value(forKeyPath: "symbolId") as? String) == stockGroup.symbolId
            && ($0.value(forKeyPath: "symbol") as? String) == stockGroup.symbol
            && ($0.value(forKeyPath: "name") as? String) == stockGroup.name
            && ($0.value(forKeyPath: "imageUrl") as? String) == stockGroup.imageUrl
            && ($0.value(forKeyPath: "price") as? String) == stockGroup.price
            && ($0.value(forKeyPath: "priceChange") as? String) == stockGroup.priceChange
        }

        cell.toggleFavoriteImage(with: isFavoriteStock)
        
        cell.didTapFavorite = { [weak self] in
            
            guard let self = self else { return }
            
            let isFavoriteStockNow = favoriteStocks.contains {
                ($0.value(forKeyPath: "symbolId") as? String) == stockGroup.symbolId
                && ($0.value(forKeyPath: "symbol") as? String) == stockGroup.symbol
                && ($0.value(forKeyPath: "name") as? String) == stockGroup.name
                && ($0.value(forKeyPath: "imageUrl") as? String) == stockGroup.imageUrl
                && ($0.value(forKeyPath: "price") as? String) == stockGroup.price
                && ($0.value(forKeyPath: "priceChange") as? String) == stockGroup.priceChange
            }
            
            if isFavoriteStockNow {
                self.favoritesViewModel?.deleteFavoriteStock(with: stockGroup, completion: { [weak self] stocks in
                    self?.favoriteStocks = stocks
                })
            } else {
                self.favoritesViewModel?.saveFavoriteStock(with: stockGroup, completion: { [weak self] stocks in
                    self?.favoriteStocks = stocks
                })
            }
            self.tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = searchResults[indexPath.row]
        delegate.passSelectedValue(selected: selectedValue)
    }
}

extension SearchResultsViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "StocksTableViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
}
