//
//  DataColor.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 30.04.2024.
//

import Foundation
import UIKit

enum DataColor {
    case first
    case second
    case third
    var color: UIColor {
        switch self {
        case .first:
            return UIColor(
                red: 56/255,
                green: 58/255,
                blue: 209/255,
                alpha: 1
            )
        case .second:
            return UIColor(
                red: 235/255,
                green: 113/255,
                blue: 52/255,
                alpha: 1
            )
        case .third:
            return UIColor(
                red: 52/255,
                green: 235/255,
                blue: 143/255,
                alpha: 1
            )
        }
    }
}
