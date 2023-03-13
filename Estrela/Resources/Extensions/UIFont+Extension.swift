//
//  UIFont+Extension.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import Foundation
import UIKit

extension UIFont {
    static func montserratRegular(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: ofSize) ?? .systemFont(ofSize: ofSize)
    }
    
    static func montserratBold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: ofSize) ?? .boldSystemFont(ofSize: ofSize)
    }
    
    static func montserratBlack(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Black", size: ofSize) ?? .systemFont(ofSize: ofSize)
    }
    
    static func montserratMedium(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: ofSize) ?? .systemFont(ofSize: ofSize, weight: .medium)
    }
    
    static func gilroyBold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Bold", size: ofSize) ?? .systemFont(ofSize: ofSize, weight: .semibold)
    }
    
    static func gilroyMedium(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Gilroy-Medium", size: ofSize) ?? .systemFont(ofSize: ofSize, weight: .medium)
    }
    
}
