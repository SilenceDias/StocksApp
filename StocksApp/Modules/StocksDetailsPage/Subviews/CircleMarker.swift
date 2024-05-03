//
//  CircleMarker.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 30.04.2024.
//

import UIKit
import DGCharts

final class CircleMarker: MarkerView {
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        context.setFillColor(UIColor.black.cgColor)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(3)
        let radius: CGFloat = 8
        let rectangle = CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        )
        context.addEllipse(in: rectangle)
        context.drawPath(using: .fillStroke)
    }
}
