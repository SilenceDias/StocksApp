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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        fetchData()
    }

    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func fetchData() {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Favorites")
        do {
            favoriteStocks = try context.fetch(fetchRequest)
            tableView.reloadData()
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
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let favoriteItem = favoriteStocks[indexPath.row] as? NSManagedObject {
            let starImageName = favoriteItem.value(forKey: "isFavorite") as? Bool ?? false ? "full_star" : "empty_star"
            cell.imageView?.image = UIImage(named: starImageName)
            if let name = favoriteItem.value(forKey: "name") as? String {
                cell.textLabel?.text = name
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let favoriteItem = favoriteStocks[indexPath.row] as? NSManagedObject {
            favoriteItem.setValue(!(favoriteItem.value(forKey: "isFavorite") as? Bool ?? false), forKey: "isFavorite")
            saveData()
            tableView.reloadData()
        }
    }
}
