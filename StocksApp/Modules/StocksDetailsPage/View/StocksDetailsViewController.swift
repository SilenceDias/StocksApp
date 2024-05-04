//
//  StocksDetailsViewController.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 30.04.2024.
//

import UIKit
import DGCharts

class StocksDetailsViewController: UIViewController {
    
    var symbol = String()
    var price = String()
    var change = String()
    
    var viewModel: DetailsViewModel?
    
    private var buyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        return button
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var yearButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .black
        button.setTitle("1Y", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(didTapYear), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    
    private lazy var sixMonthButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        button.setTitle("6M", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(didTapSix), for: .touchUpInside)
        return button
    }()
    
    private lazy var monthButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        button.setTitle("M", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(didTapMonth), for: .touchUpInside)
        return button
    }()
    
    private lazy var weekButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        button.setTitle("W", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(didTapWeek), for: .touchUpInside)
        return button
    }()
    
    private lazy var dayButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        button.setTitle("D", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.addTarget(self, action: #selector(didTapDay), for: .touchUpInside)
        return button
    }()
    
    private var peridosButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var bubleView: Bubble = {
        let bubble = Bubble()
        bubble.isHidden = true
        return bubble
    }()
    
    private var chart: LineChartView = {
        let chart = LineChartView()
        let circleMarker = CircleMarker()
        // отключаем координатную сетку
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.drawGridBackgroundEnabled = false
        // отключаем подписи к осям
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        // отключаем легенду
        chart.legend.enabled = false
        // отключаем зум
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        // убираем артефакты вокруг области графика
        chart.xAxis.enabled = false
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.minOffset = 0
        // устанавливаем делегата, нужно для обработки нажатий
      
        chart.drawMarkers = true
        circleMarker.chartView = chart
        chart.marker = circleMarker
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = symbol
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        buildChart()
        setupViews()
    }
    
    func buildChart(){
        viewModel = DetailsViewModel()
        var lineChartEntries = [ChartDataEntry]()
        var counter = 1
        
        chart.delegate = self
        
        viewModel?.loadData(symbol: symbol, completion: { [weak self] prices in
            prices.forEach {
                lineChartEntries.append(.init(x: Double(counter), y: $0.prices, data: $0.data))
                counter += 1
            }
            let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
            let dataSet = ChartDatasetFactory.init().makeChartDataset(colorAsset: color, entries: lineChartEntries)
            let data = LineChartData(dataSet: dataSet)
            self?.chart.data = data
        })
    }
    
    private func setupViews(){
        [priceLabel, changeLabel, buyButton, peridosButtonsStack, chart, bubleView].forEach {
            view.addSubview($0)
        }
        [dayButton, weekButton, monthButton, sixMonthButton, yearButton].forEach {
            peridosButtonsStack.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(45)
            }
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(63)
            make.left.right.equalToSuperview().inset(18)
        }
        priceLabel.text = price
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(18)
        }
        if change.first == "-" {
            changeLabel.textColor = .systemRed
        }
        else {
            changeLabel.textColor = .systemGreen
        }
        changeLabel.text = change
        
        buyButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        buyButton.setTitle("But for $\(price)", for: .normal)
        
        chart.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(300)
        }
        
        peridosButtonsStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(326)
            make.height.equalTo(56)
            make.top.equalTo(chart.snp.bottom).offset(40)
        }
        bubleView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.width.equalTo(99)
        }
    }
    
    @objc func didTapYear(){
        sixMonthButton.isSelected = false
        sixMonthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        monthButton.isSelected = false
        monthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        weekButton.isSelected = false
        weekButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        dayButton.isSelected = false
        dayButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        yearButton.isSelected = true
        yearButton.backgroundColor = .black
        var lineChartEntries = [ChartDataEntry]()
        var counter = 1
        var prices = viewModel?.getYear()
        
        prices?.forEach({
            lineChartEntries.append(.init(x: Double(counter), y: $0.prices, data: $0.data))
            counter += 1
        })
        
        print(prices)
        
        let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let dataSet = ChartDatasetFactory.init().makeChartDataset(colorAsset: color, entries: lineChartEntries)
        let data = LineChartData(dataSet: dataSet)
        self.chart.data = data
    }
    
    @objc func didTapMonth(){
        yearButton.isSelected = false
        yearButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        sixMonthButton.isSelected = false
        sixMonthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        weekButton.isSelected = false
        weekButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        dayButton.isSelected = false
        dayButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        monthButton.isSelected = true
        monthButton.backgroundColor = .black
        var lineChartEntries = [ChartDataEntry]()
        var counter = 1
        var prices = viewModel?.getOneMonth()
        
        prices?.forEach({
            lineChartEntries.append(.init(x: Double(counter), y: $0.prices, data: $0.data))
            counter += 1
        })
        
        print(prices)
        
        let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let dataSet = ChartDatasetFactory.init().makeChartDataset(colorAsset: color, entries: lineChartEntries)
        let data = LineChartData(dataSet: dataSet)
        self.chart.data = data
    }
    
    @objc func didTapSix(){
        yearButton.isSelected = false
        yearButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        monthButton.isSelected = false
        monthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        weekButton.isSelected = false
        weekButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        dayButton.isSelected = false
        dayButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        sixMonthButton.isSelected = true
        sixMonthButton.backgroundColor = .black
        var lineChartEntries = [ChartDataEntry]()
        var counter = 1
        var prices = viewModel?.getSixMonth()
        
        prices?.forEach({
            lineChartEntries.append(.init(x: Double(counter), y: $0.prices, data: $0.data))
            counter += 1
        })
        
        print(prices)
        
        let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let dataSet = ChartDatasetFactory.init().makeChartDataset(colorAsset: color, entries: lineChartEntries)
        let data = LineChartData(dataSet: dataSet)
        self.chart.data = data
    }
    
    @objc func didTapWeek(){
        yearButton.isSelected = false
        yearButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        monthButton.isSelected = false
        monthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        sixMonthButton.isSelected = false
        sixMonthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        dayButton.isSelected = false
        dayButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        weekButton.isSelected = true
        weekButton.backgroundColor = .black
        var lineChartEntries = [ChartDataEntry]()
        var counter = 1
        var prices = viewModel?.getWeek()
        
        prices?.forEach({
            lineChartEntries.append(.init(x: Double(counter), y: $0.prices, data: $0.data))
            counter += 1
        })
        
        print(prices)
        
        let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let dataSet = ChartDatasetFactory.init().makeChartDataset(colorAsset: color, entries: lineChartEntries)
        let data = LineChartData(dataSet: dataSet)
        self.chart.data = data
    }
    
    @objc func didTapDay(){
        yearButton.isSelected = false
        yearButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        monthButton.isSelected = false
        monthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        sixMonthButton.isSelected = false
        sixMonthButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        weekButton.isSelected = false
        weekButton.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 247/255.0, alpha: 1.0)
        dayButton.isSelected = true
        dayButton.backgroundColor = .black
        var lineChartEntries = [ChartDataEntry]()
        var counter = 1
        var prices = viewModel?.getDay()
        
        prices?.forEach({
            lineChartEntries.append(.init(x: Double(counter), y: $0.prices, data: $0.data))
            counter += 1
        })
        
        print(prices)
        
        let color = UIColor(red: 26/255.0, green: 26/255.0, blue: 26/255.0, alpha: 1.0)
        let dataSet = ChartDatasetFactory.init().makeChartDataset(colorAsset: color, entries: lineChartEntries)
        let data = LineChartData(dataSet: dataSet)
        self.chart.data = data
    }
}

extension StocksDetailsViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        bubleView.isHidden = false
        bubleView.center.x = highlight.xPx
        bubleView.center.y = highlight.yPx + 200
        let dataOfBubble = entry.data as! String
        let price = "String(highlight.y)"
        bubleView.configure(price: price, date: dataOfBubble)
    }
}
