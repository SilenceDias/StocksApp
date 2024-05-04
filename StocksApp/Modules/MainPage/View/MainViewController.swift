//
//  MainViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    
    private lazy var favoriteStocks:[NSManagedObject] = []
    
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
    
    private func loadFavorites() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        
        do {
            
            favoriteStocks = try context.fetch(fetchRequest)
        } catch  let error as NSError{
            
            print("Could not fetch. Error: \(error)")
        }
    }
    
//    private func saveFavoriteMovie(with movie: Result) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        guard let entity = NSEntityDescription.entity(
//            forEntityName: "FavoriteMovies",
//            in: managedContext
//        ) else { return }
//        
//        let favoriteMovie = NSManagedObject(entity: entity, insertInto: managedContext)
//        favoriteMovie.setValue(movie.id, forKey: "id")
//        favoriteMovie.setValue(movie.title, forKey: "title")
//        favoriteMovie.setValue(movie.posterPath, forKey: "posterPath")
//        
//        do {
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not save. Error: \(error)")
//        }
//    }
//    
//    private func deleteFavoriteMovie(with movie: Result) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
//        let predicate1 = NSPredicate(format: "id == %@", "\(movie.id)")
//        let predicate2 = NSPredicate(format: "title == %@", movie.title)
//        let predicate3 = NSPredicate(format: "posterPath == %@", movie.posterPath)
//        let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [predicate1, predicate2, predicate3])
//        fetchRequest.predicate = predicateAll
//        
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            let data = results.first
//            if let data {
//                managedContext.delete(data)
//            }
//            try managedContext.save()
//        } catch let error as NSError {
//            print("Could not delete. Error: \(error)")
//        }
//    }
    
    private func setupViews(){
        view.addSubview(recommendedTableView)
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Stocks"
        
        recommendedTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupViewModel(){
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
        let data = viewModel?.getCellViewModel(at: indexPath)
        cell.configure(data: data)
//        
//        let isFavoriteMovie = !self.favoriteMovies.filter({ ($0.value(forKeyPath: "id") as? Int) == movie.id}).isEmpty
//        cell.toggleFavoriteImage(with: isFavoriteMovie)
        
//        cell.didTapFavorite = { [weak self] in
//            guard let self else { return }
//            let isFavoriteMovie = !self.favoriteMovies.filter({ ($0.value(forKeyPath: "id") as? Int) == movie.id}).isEmpty
//            cell.toggleFavoriteImage(with: isFavoriteMovie)
//            
//            if isFavoriteMovie {
//                self.deleteFavoriteMovie(with: movie)
//            } else {
//                self.saveFavoriteMovie(with: movie)
//            }
//            
//            self.movieTableView.reloadData()
//        }
        
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
