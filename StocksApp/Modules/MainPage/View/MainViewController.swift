//
//  MainViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit
import CoreData
import SnapKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    private var favoriteStocks: [NSManagedObject] = []
    
    private lazy var recommendedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(
            StocksTableViewCell.self,
            forCellReuseIdentifier: "StocksTableViewCell"
        )
        tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        loadFavorites()
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

    private func saveFavoriteStock(with stock: StocksDataModel) {
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
            }
        } catch let error as NSError {
            print("Could not delete. Error: \(error)")
        }
    }

    
    private func setupViews() {
        view.addSubview(recommendedTableView)
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Stocks"
        
        recommendedTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel = MainViewModel()
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.loadData(comletion: {
                self?.recommendedTableView.reloadData()
            })
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections ?? 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SectionHeader else {
            fatalError()
        }
        let headerTitle = viewModel?.getHeaderTitle(section: section) ?? ""
        header.configure(title: headerTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberInSection(section: section) ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recommendedTableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as! StocksTableViewCell
        guard let data = viewModel?.getCellViewModel(at: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(data: data)
        
        let isFavoriteStock = favoriteStocks.contains { ($0.value(forKeyPath: "symbolId") as? String) == data.symbolId }

        cell.toggleFavoriteImage(with: isFavoriteStock)
        
        cell.didTapFavorite = { [weak self] in
            guard let self = self else { return }
            
            if isFavoriteStock {
                self.deleteFavoriteStock(with: data)
            } else {
                self.saveFavoriteStock(with: data)
            }
            self.recommendedTableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StocksDetailsViewController()
        guard let data = viewModel?.getCellViewModel(at: indexPath) else {
            return
        }
        vc.symbol = data.symbol
        vc.price = data.price
        vc.change = data.priceChange + "(\(data.changePercentage))"
        navigationController?.pushViewController(vc, animated: true)
    }
}
