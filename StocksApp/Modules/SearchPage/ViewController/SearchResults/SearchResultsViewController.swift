//
//  SearchResultsViewController.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import UIKit

class SearchResultsViewController: UIViewController {
    private var tableView: UITableView = UITableView()
    private var searchResults: [Stock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func update(with stocks: [Stock]) {
        searchResults = stocks
        tableView.reloadData()
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let stock = searchResults[indexPath.row]
        cell.textLabel?.text = stock.profile.name
        cell.detailTextLabel?.text = stock.ticker.displaySymbol
        return cell
    }
}


//import UIKit
//import SnapKit
//
//protocol SearchResultsViewControllerDelegate {
//    func showResult(_ controller: UIViewController)
//}
//
//class SearchResultsViewController: UIViewController {
//    
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.isHidden = true
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return tableView
//    }()
//    
//    var numberOfRows: Int = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        numberOfRows = 10
//    }
//    
//    func update(with Stocks: [Stock]) {
//    }
//}
//
//extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return numberOfRows
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    }
//}
