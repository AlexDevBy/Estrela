//
//  CustomCheckbox.swift
//  Estrela
//
//  Created by Alex Misko on 28.12.22.
//

import Foundation
import UIKit

class CustomCheckbox: UIButton {
    
    let selectedImg = #imageLiteral(resourceName: "check")
    let notSelectedImg = #imageLiteral(resourceName: "uncheck")
    
    var isSelect: Bool = false {
        didSet {
            self.setImage()
        }
    }
    
    func setImage() {
        self.setImage(isSelect ? selectedImg : notSelectedImg, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setImage()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setImage()
    }
    
    public func toggle() {
        self.isSelect.toggle()
        self.setImage()
    }
    
}
