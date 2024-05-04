//
//  BaseViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 04.05.2024.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    
    var favoriteStocks: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadFavorites() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        
        do {
            favoriteStocks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. Error: \(error)")
        }
    }

    func saveFavoriteStock(with stock: StocksDataModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "symbolId == %@", stock.symbolId)
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
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
                
                try context.save()
                favoriteStocks.append(favoriteStock)
            }
        } catch let error as NSError {
            print("Could not save. Error: \(error)")
        }
    }

    func deleteFavoriteStock(with stock: StocksDataModel) {
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
            }
        } catch let error as NSError {
            print("Could not delete. Error: \(error)")
        }
    }
}
