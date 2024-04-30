//
//  SearchResultsViewController.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import UIKit

class SearchResultsViewController: UIViewController {
    private var searchResults: [StocksGroup] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "StocksTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with stocks: [StocksGroup]) {
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
        if let firstStock = stockGroup.stocks.first {
            cell.configure(data: firstStock)
        }
        return cell
    }
}
