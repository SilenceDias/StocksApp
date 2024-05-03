//
//  TabBarViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let icons: [UIImage?] = [
        UIImage(systemName: "chart.line.uptrend.xyaxis"),
        UIImage(systemName: "star"),
        UIImage(systemName: "magnifyingglass")
    ]
    
    private var allViewControllers = [
        UINavigationController(rootViewController: MainViewController()),
        UINavigationController(rootViewController: StocksDetailsViewController()),
        UINavigationController(rootViewController: SearchViewController())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBarViews()
    }
    
    //MARK: Methods
    private func makeTabBarViews(){
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .white
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        view.backgroundColor = .white
        tabBar.tintColor = UIColor(red: 6/255.0, green: 125/255.0, blue: 246/255.0, alpha: 1.0)
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        setViewControllers(allViewControllers, animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        for i in 0..<items.count {
            items[i].image = icons[i]
        }
        
        allViewControllers.forEach {
            $0.navigationBar.prefersLargeTitles = true
        }
    }
}
