//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit
import SnapKit
import Kingfisher

class StocksTableViewCell: UITableViewCell {
    
    private var logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private var priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGreen
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func configure(data: StocksDataModel?) {
        guard let data else { return }
        self.symbolLabel.text = data.symbol
        self.descriptionLabel.text = data.name
        self.priceLabel.text = "$\(data.price)"
       
        if data.priceChange.first == "-" {
            priceChangeLabel.textColor = .red
            self.priceChangeLabel.text = "$\(data.priceChange)(\(data.changePercentage))"
        }
        else {
            self.priceChangeLabel.text = "+$\(data.priceChange)(\(data.changePercentage))"
        }
        let url = URL(string: data.imageUrl)
        logoImage.kf.setImage(with: url)
    }
    
    
    private func setupViews(){
        
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        
        backgroundColor = .clear
        
        [logoImage, symbolLabel, descriptionLabel, priceLabel, priceChangeLabel].forEach {
            contentView.addSubview($0)
        }
        
        logoImage.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        symbolLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(logoImage.snp.right).offset(12)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolLabel.snp.bottom)
            make.left.equalTo(logoImage.snp.right).offset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.right.equalToSuperview().inset(12)
        }
        
        priceChangeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.right.equalToSuperview().inset(12)
        }
    }

}
