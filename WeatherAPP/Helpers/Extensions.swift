//
//  Extensions.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 5.06.2023.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
extension UIViewController {
    func backGraoundGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.label.cgColor]
        gradient.frame = view.bounds
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
    }
}

