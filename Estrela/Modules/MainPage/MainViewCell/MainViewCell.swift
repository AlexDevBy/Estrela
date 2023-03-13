//
//  MainViewCell.swift
//  Estrela
//
//  Created by Alex Misko on 27.12.22.
//

import UIKit

class MainViewCell: UITableViewCell {

    @IBOutlet weak var noAnswr: UILabel!
    @IBOutlet weak var yesAnswer: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var mainBgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainBgView.layer.borderWidth = 1
        self.mainBgView.layer.borderColor = UIColor(hexFromString: "00336B").cgColor
        self.mainBgView.layer.cornerRadius = 5
        self.mainBgView.layer.masksToBounds = true
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.backgroundColor = UIColor(hexFromString: "001D3D")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
