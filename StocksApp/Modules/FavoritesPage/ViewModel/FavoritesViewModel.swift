//
//  FavoritesViewModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 04.05.2024.
//

import Foundation
import CoreData
import UIKit

class FavoritesViewModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var favoriteStocks = [NSManagedObject]()
    
    func getFavorites() -> [NSManagedObject]{
        return favoriteStocks
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Favorites")
        do {
            let fetchedStocks = try context.fetch(fetchRequest)
            favoriteStocks = fetchedStocks
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }

    func saveFavoriteStock(with stock: StocksDataModel, completion: @escaping ([NSManagedObject]) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        do {
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
            
            favoriteStocks.append(favoriteStock)
            
            try context.save()
            fetchData()
            completion(favoriteStocks)
        } catch let error as NSError {
            print("Could not save. Error: \(error)")
        }
    }

    func deleteFavoriteStock(with stock: StocksDataModel, completion: @escaping ([NSManagedObject]) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        let predicate1 = NSPredicate(format: "symbolId == %@", stock.symbolId)
        let predicate2 = NSPredicate(format: "symbol == %@", stock.symbol)
        let predicate3 = NSPredicate(format: "name == %@", stock.name)
        let predicate4 = NSPredicate(format: "price == %@", stock.price)
        let predicate5 = NSPredicate(format: "priceChange == %@", stock.priceChange)
        let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [
            predicate1, predicate2, predicate3, predicate4, predicate5
        ])
        fetchRequest.predicate = predicateAll
        
        do {
            let results = try context.fetch(fetchRequest)
            if let data = results.first {
                context.delete(data)
                try context.save()
                if let index = favoriteStocks.firstIndex(of: data) {
                    favoriteStocks.remove(at: index)
                    completion(favoriteStocks)
                }
            }
        } catch let error as NSError {
            print("Could not delete. Error: \(error)")
        }
    }
}
