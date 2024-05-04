//
//  LoadingView.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 05.05.2024.
//

import UIKit
import Lottie

class LoadingView: UIView {
    
    private enum Constants {
        static let animationViewSize: CGSize = .init(width: 95, height: 200)
    }
    
    // MARK: Properties
    private let containerView = UIView()
    
    private var isLoading: Bool = false

    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loaderStocks")
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.25
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: Methods
    private func setupAnimation() {
        addSubview(containerView)
        
        containerView.addSubview(animationView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.animationViewSize)
        }
    }
    
    func startLoading(){
        if isLoading {return}
        
        isLoading = true
        
        animationView.play(
            fromProgress: animationView.currentProgress,
            toProgress: 1,
            loopMode: .loop
        )
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    func stopLoading() {
        isLoading = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.animationView.stop()
        }
    }
}
