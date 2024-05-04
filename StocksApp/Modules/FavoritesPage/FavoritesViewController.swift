//
//  FavoritesViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit
import CoreData
import SnapKit

class FavoritesViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favoriteStocks: [NSManagedObject] = []
    
    var viewModel: FavoritesViewModel?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "StocksTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        view.backgroundColor = .white
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewModel()
    }
    
    private func setupViewModel(){
        viewModel = FavoritesViewModel()
        viewModel?.fetchData()
        favoriteStocks = viewModel?.getFavorites() ?? [NSManagedObject]()
        tableView.reloadData()
    }

    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStocks.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as! StocksTableViewCell
        if let favoriteItem = favoriteStocks[indexPath.row] as? NSManagedObject {
            let name = favoriteItem.value(forKey: "name") as? String ?? ""
            let symbol = favoriteItem.value(forKey: "symbol") as? String ?? ""
            let imageUrl = favoriteItem.value(forKey: "imageUrl") as? String ?? ""
            let price = favoriteItem.value(forKey: "price") as? String ?? ""
            let priceChange = favoriteItem.value(forKey: "priceChange") as? String ?? ""
            let symbolId = favoriteItem.value(forKey: "symbolId") as? String ?? ""
            
            let data = StocksDataModel(symbol: symbol, name: name, symbolId: symbolId, imageUrl: imageUrl, price: price, priceChange: priceChange, changePercentage: "")
            cell.configure(data: data)
            cell.setFavorite()
            cell.didTapFavorite = { [weak self] in
                self?.viewModel?.deleteFavoriteStock(with: data, completion: { [weak self] stocks in
                    self?.favoriteStocks = stocks
                    self?.tableView.reloadData()
                })
            }
        }
        return cell
    }
}

