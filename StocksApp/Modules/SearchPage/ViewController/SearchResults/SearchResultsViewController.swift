//
//  SearchResultsViewController.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import UIKit

class SearchResultsViewController: UIViewController {
    private var searchResults: [StocksDataModel] = []
//    weak var favoritesDelegate: FavoritesViewControllerDelegate?

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
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .white
        
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
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as! StocksTableViewCell
        let stockGroup = searchResults[indexPath.row]
        cell.configure(data: stockGroup)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStock = searchResults[indexPath.row]
//        if isFavorite(selectedStock) {
//            favoritesDelegate?.removeFromFavorites(selectedStock)
//        } else {
//            favoritesDelegate?.addToFavorites(selectedStock)
//        }
    }

    private func isFavorite(_ stock: StocksDataModel) -> Bool {
        return false
    }
}

//extension SearchResultsViewController: FavoritesViewControllerDelegate {
//    func saveFavorites() {
//        do {
//            try context.save()
//                tableView.reloadData()
//        } catch {
//            print("Error saving data: \(error)")
//        }
//    }
//    
//    func addToFavorites(_ stock: StocksDataModel) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//        fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
//        
//        do {
//            let result = try context.fetch(fetchRequest)
//            for object in result {
//                context.delete(object as! NSManagedObject)
//            }
//            
//            guard let entity = NSEntityDescription.entity(
//                forEntityName: "Favorites",
//                in: context
//            ) else { return }
//            
//            let favoriteStock = NSManagedObject(entity: entity, insertInto: context)
//            favoriteStock.setValue(stock.symbol, forKey: "symbol")
//            favoriteStock.setValue(stock.symbolId, forKey: "symbolId")
//            favoriteStock.setValue(stock.name, forKey: "name")
//            favoriteStock.setValue(stock.imageUrl, forKey: "imageUrl")
//            favoriteStock.setValue(stock.price, forKey: "price")
//            favoriteStock.setValue(stock.priceChange, forKey: "priceChange")
//            favoriteStock.setValue(true, forKey: "isFavorite")
//            
//            favoriteStocks.append(favoriteStock)
//            
//            try context.save()
//            fetchData()
//        } catch let error as NSError {
//            print("Could not save. Error: \(error)")
//        }    }
//    
//    func removeFromFavorites(_ stock: StocksDataModel) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
//        fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let data = results.first {
//                context.delete(data)
//                try context.save()
//                if let index = favoriteStocks.firstIndex(of: data) {
//                    favoriteStocks.remove(at: index)
//                }
//                tableView.reloadData()
//            }
//        } catch let error as NSError {
//            print("Could not delete. Error: \(error)")
//        }
//    }
//}
//    
//    func saveFavorites() {
//        do {
//            try context.save()
//                tableView.reloadData()
//        } catch {
//            print("Error saving data: \(error)")
//        }
//    }
//}
