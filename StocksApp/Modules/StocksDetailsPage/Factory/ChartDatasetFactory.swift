//
//  ChartDatasetFactory.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 30.04.2024.
//

import Foundation
import DGCharts
import CoreGraphics
import UIKit
struct ChartDatasetFactory {
    func makeChartDataset(
        colorAsset: UIColor,
        entries: [ChartDataEntry]
    ) -> LineChartDataSet {
        var dataSet = LineChartDataSet(entries: entries, label: "")
        // общие настройки графика
        dataSet.setColor(colorAsset)
        dataSet.lineWidth = 3
        dataSet.mode = .cubicBezier // сглаживание
        dataSet.drawValuesEnabled = false // убираем значения на графике
        dataSet.drawCirclesEnabled = false // убираем точки на графике
        dataSet.drawFilledEnabled = true // нужно для градиента
        dataSet.drawHorizontalHighlightIndicatorEnabled = false // оставляем только вертикальную линию
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        addGradient(to: &dataSet, colorAsset: colorAsset)
        return dataSet
    }
}
private extension ChartDatasetFactory {
    func addGradient(
        to dataSet: inout LineChartDataSet,
        colorAsset: UIColor
    ) {
        let mainColor = colorAsset.withAlphaComponent(0.5)
        let secondaryColor = colorAsset.withAlphaComponent(0)
        let colors = [
            mainColor.cgColor,
            secondaryColor.cgColor,
            secondaryColor.cgColor
        ] as CFArray
        let locations: [CGFloat] = [0, 0.79, 1]
        if let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors,
            locations: locations
        ) {
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270 )
        }
    }
} 
