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
        fetchData()
    }

    private func setupViews() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Favorites")
        do {
            let fetchedStocks = try context.fetch(fetchRequest)
            
            // Create a set to store unique values based on symbolId.
            var uniqueStocks: Set<String> = Set()
            var uniqueFavoriteStocks: [NSManagedObject] = []
            
            // Iterate over all items and check for uniqueness based on symbolId.
            for stock in fetchedStocks {
                guard let symbolId = stock.value(forKey: "symbolId") as? String else {
                    continue
                }
                if !uniqueStocks.contains(symbolId) {
                    uniqueStocks.insert(symbolId)
                    uniqueFavoriteStocks.append(stock)
                }
            }
            
            // Replace the current array with unique elements.
            favoriteStocks = uniqueFavoriteStocks
            
            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func saveData() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving data: \(error)")
        }
    }

    private func saveFavoriteStock(with stock: StocksDataModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
        
        do {
            let result = try context.fetch(fetchRequest)
            for object in result {
                context.delete(object as! NSManagedObject)
            }
            
            guard let entity = NSEntityDescription.entity(
                forEntityName: "Favorites",
                in: context
            ) else { return }
            
            let favoriteStock = NSManagedObject(entity: entity, insertInto: context)
            favoriteStock.setValue(stock.symbol, forKey: "symbol")
            favoriteStock.setValue(stock.symbolId, forKey: "symbolId")
            favoriteStock.setValue(stock.name, forKey: "name")
            favoriteStock.setValue(stock.imageUrl, forKey: "imageUrl")
            favoriteStock.setValue(stock.price, forKey: "price")
            favoriteStock.setValue(stock.priceChange, forKey: "priceChange")
            favoriteStock.setValue(true, forKey: "isFavorite")
            
            favoriteStocks.append(favoriteStock)
            
            try context.save()
            fetchData()
        } catch let error as NSError {
            print("Could not save. Error: \(error)")
        }
    }

    private func deleteFavoriteStock(with stock: StocksDataModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let data = results.first {
                context.delete(data)
                try context.save()
                if let index = favoriteStocks.firstIndex(of: data) {
                    favoriteStocks.remove(at: index)
                }
                tableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not delete. Error: \(error)")
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
            let isFavorite = favoriteItem.value(forKey: "isFavorite") as? Bool ?? false
            let symbolId = favoriteItem.value(forKey: "symbolId") as? String ?? ""
            
            let data = StocksDataModel(symbol: "", name: symbol, symbolId: symbolId, imageUrl: imageUrl, price: price, priceChange: priceChange, changePercentage: "")
            cell.configure(data: data)
            cell.toggleFavoriteImage(with: isFavorite)
            cell.didTapFavorite = { [weak self] in
                self?.deleteFavoriteStock(with: data)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let favoriteItem = favoriteStocks[indexPath.row] as? NSManagedObject {
            let currentIsFavorite = favoriteItem.value(forKey: "isFavorite") as? Bool ?? false
            favoriteItem.setValue(!currentIsFavorite, forKey: "isFavorite")
            
            saveData()
            
            tableView.reloadData()
        }
    }
}

////protocol FavoritesViewControllerDelegate: AnyObject {
////    func addToFavorites(_ stock: StocksDataModel)
////    func removeFromFavorites(_ stock: StocksDataModel)
////    func saveFavorites()
////}
//
//class FavoritesViewController: UIViewController {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var favoriteStocks: [NSManagedObject] = []
////    weak var delegate: FavoritesViewControllerDelegate?
//    
////    lazy var tableView: UITableView = {
////        let tableView = UITableView(frame: .zero, style: .plain)
////        tableView.dataSource = self
////        tableView.delegate = self
////        tableView.estimatedRowHeight = 70
////        tableView.rowHeight = 64
////        tableView.separatorStyle = .none
////        tableView.backgroundColor = .clear
////        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "StocksTableViewCell")
////        tableView.translatesAutoresizingMaskIntoConstraints = false
////        return tableView
////    }()
//    lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Favorite"
//        view.backgroundColor = .white
//        setupViews()
//        fetchData()
//    }
//    
//    private func setupViews() {
//        view.addSubview(tableView)
//        
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
//            make.left.right.bottom.equalToSuperview()
//        }
//    }
//    
//    func fetchData() {
//        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Favorites")
//        do {
//            let fetchedStocks = try context.fetch(fetchRequest)
//            
//            var uniqueStocks: Set<String> = Set()
//            var uniqueFavoriteStocks: [NSManagedObject] = []
//            
//            for stock in fetchedStocks {
//                guard let symbolId = stock.value(forKey: "symbolId") as? String else {
//                    continue
//                }
//                if !uniqueStocks.contains(symbolId) {
//                    uniqueStocks.insert(symbolId)
//                    uniqueFavoriteStocks.append(stock)
//                }
//            }
//            
//            favoriteStocks = uniqueFavoriteStocks
//            
//            tableView.reloadData()
//        } catch {
//            print("Error fetching data: \(error)")
//        }
//    }
//    
////    private func saveFavoriteStock(with stock: StocksDataModel) {
////        delegate?.addToFavorites(stock)
////    }
////    
////    private func deleteFavoriteStock(with stock: StocksDataModel) {
////        delegate?.removeFromFavorites(stock)
////    }
//    
//        func saveData() {
//            do {
//                try context.save()
//                tableView.reloadData()
//            } catch {
//                print("Error saving data: \(error)")
//            }
//        }
//    
//        private func saveFavoriteStock(with stock: StocksDataModel) {
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let context = appDelegate.persistentContainer.viewContext
//    
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
//            fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
//    
//            do {
//                let result = try context.fetch(fetchRequest)
//                for object in result {
//                    context.delete(object as! NSManagedObject)
//                }
//    
//                guard let entity = NSEntityDescription.entity(
//                    forEntityName: "Favorites",
//                    in: context
//                ) else { return }
//    
//                let favoriteStock = NSManagedObject(entity: entity, insertInto: context)
//                favoriteStock.setValue(stock.symbol, forKey: "symbol")
//                favoriteStock.setValue(stock.symbolId, forKey: "symbolId")
//                favoriteStock.setValue(stock.name, forKey: "name")
//                favoriteStock.setValue(stock.imageUrl, forKey: "imageUrl")
//                favoriteStock.setValue(stock.price, forKey: "price")
//                favoriteStock.setValue(stock.priceChange, forKey: "priceChange")
//                favoriteStock.setValue(true, forKey: "isFavorite")
//    
//                favoriteStocks.append(favoriteStock)
//    
//                try context.save()
//                fetchData()
//            } catch let error as NSError {
//                print("Could not save. Error: \(error)")
//            }
//        }
//    
//        private func deleteFavoriteStock(with stock: StocksDataModel) {
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let context = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
//            fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
//    
//            do {
//                let results = try context.fetch(fetchRequest)
//                if let data = results.first {
//                    context.delete(data)
//                    try context.save()
//                    if let index = favoriteStocks.firstIndex(of: data) {
//                        favoriteStocks.remove(at: index)
//                    }
//                    tableView.reloadData()
//                }
//            } catch let error as NSError {
//                print("Could not delete. Error: \(error)")
//            }
//        }
//    }
//    
//    extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return favoriteStocks.count
//        }
//        
//        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 44
//        }
//        
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 88
//        }
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//                    if let favoriteItem = favoriteStocks[indexPath.row] as? NSManagedObject {
//                        let name = favoriteItem.value(forKey: "name") as? String ?? ""
//                        let symbol = favoriteItem.value(forKey: "symbol") as? String ?? ""
//                        let imageUrl = favoriteItem.value(forKey: "imageUrl") as? String ?? ""
//                        let price = favoriteItem.value(forKey: "price") as? String ?? ""
//                        let priceChange = favoriteItem.value(forKey: "priceChange") as? String ?? ""
//                        let isFavorite = favoriteItem.value(forKey: "isFavorite") as? Bool ?? false
//                        let symbolId = favoriteItem.value(forKey: "symbolId") as? String ?? ""
//            
//                        let data = StocksDataModel(symbol: "", name: symbol, symbolId: symbolId, imageUrl: imageUrl, price: price, priceChange: priceChange, changePercentage: "")
//                        cell.configure(data: data)
//                        cell.toggleFavoriteImage(with: isFavorite)
//                        cell.didTapFavorite = { [weak self] in
//                            self?.deleteFavoriteStock(with: data)
//                        }
//                    }
//            return cell
//        }
//        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if let favoriteItem = favoriteStocks[indexPath.row] as? NSManagedObject {
//                let currentIsFavorite = favoriteItem.value(forKey: "isFavorite") as? Bool ?? false
//                favoriteItem.setValue(!currentIsFavorite, forKey: "isFavorite")
//                
//                            saveData()
//                
//                tableView.reloadData()
//            }
//        }
//}
