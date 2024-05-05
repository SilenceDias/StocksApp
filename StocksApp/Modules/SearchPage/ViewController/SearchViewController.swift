//
//  SearchViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit
import SkeletonView

class SearchViewController: BaseViewController, UISearchBarDelegate {
    
    var viewModel: SearchViewModel?
    
    private var notFoundImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "not_found")
        return image
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .black
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
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
        tableView.backgroundColor = .black
        tableView.isSkeletonable = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Search"
        setupViews()
        setupViewModel()
        self.searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        view.addSubview(tableView)
        view.addSubview(notFoundImageView)
        
        notFoundImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupViewModel(){
        viewModel = SearchViewModel()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let resultsViewController = searchController.searchResultsController as?
                SearchResultsViewController,
            let text = searchController.searchBar.text,
            !text.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        resultsViewController.delegate = self
        showLoader()
        viewModel?.search(query: text, completion: { [weak self] stocks in
            resultsViewController.update(with: stocks)
            self?.hideLoader()
        })
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource, SearchTableDelegate {
    func passSelectedValue(selected stock: StocksDataModel) {
        let vc = StocksDetailsViewController()
        let data = stock
        vc.symbol = data.symbol
        vc.price = data.price
        vc.change = (data.priceChange) + "(\(String(describing: data.changePercentage)))"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.getNumberOfItems())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableViewCell", for: indexPath) as! StocksTableViewCell
        let data = viewModel?.getCellViewModel(at: indexPath)
        cell.configure(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StocksDetailsViewController()
        let data = viewModel?.getCellViewModel(at: indexPath)
        vc.symbol = data?.symbol ?? ""
        vc.price = data?.price ?? ""
        vc.change = (data?.priceChange ?? "") + "(\(String(describing: data?.changePercentage)))"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


