//
//  MainViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit
import CoreData
import SnapKit
import SkeletonView

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    var favoritesViewModel: FavoritesViewModel?
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
        tableView.isSkeletonable = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewModelFavorites()
    }
    
    private func setupViewModelFavorites(){
        favoritesViewModel = FavoritesViewModel()
        favoritesViewModel?.fetchData()
        favoriteStocks = favoritesViewModel?.getFavorites() ?? [NSManagedObject]()
        recommendedTableView.reloadData()
    }
    
    private func setupViews() {
        view.addSubview(recommendedTableView)
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Stocks"
        
        recommendedTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel = MainViewModel()
        recommendedTableView.showAnimatedGradientSkeleton()
        DispatchQueue.main.async { [weak self] in
            self?.viewModel?.loadData(comletion: {
                self?.recommendedTableView.reloadData()
                self?.recommendedTableView.hideSkeleton()
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
                self.favoritesViewModel?.deleteFavoriteStock(with: data, completion: { [weak self] stocks in
                    self?.favoriteStocks = stocks
                })
            } else {
                self.favoritesViewModel?.saveFavoriteStock(with: data, completion: { [weak self] stocks in
                    self?.favoriteStocks = stocks
                })
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

extension MainViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "StocksTableViewCell"
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 3
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
}
