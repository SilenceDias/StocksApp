//
//  MainViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    
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
    }
    
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
        return cell
    }
}
