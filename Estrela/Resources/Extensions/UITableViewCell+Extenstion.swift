//
//  UITableViewCell+Extenstion.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import UIKit

extension UITableViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

}
