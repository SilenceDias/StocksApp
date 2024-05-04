//
//  BaseViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 04.05.2024.
//

import UIKit
import CoreData

class BaseViewController: UIViewController {
    
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.layer.zPosition = 10
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0
        view.frame = view.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews(){
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showLoader(){
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.startLoading()
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopLoading()
        }
    }
    
}
