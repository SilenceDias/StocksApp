//
//  SectionHeader.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {

    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String){
        self.symbolLabel.text = title
    }
    
    private func setupViews(){
        contentView.addSubview(symbolLabel)
        
        symbolLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
        }
    }

}
