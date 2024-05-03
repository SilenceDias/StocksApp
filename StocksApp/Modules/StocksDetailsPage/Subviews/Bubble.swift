//
//  Bubble.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 03.05.2024.
//

import UIKit

class Bubble: UIView {
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(red: 186/255.0, green: 186/255.0, blue: 186/255.0, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        backgroundColor = .black
        layer.cornerRadius = 15
        
        addSubview(priceLabel)
        addSubview(dateLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(1)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    func configure(price: String, date: String){
        priceLabel.text = price
        dateLabel.text = date
    }
}
