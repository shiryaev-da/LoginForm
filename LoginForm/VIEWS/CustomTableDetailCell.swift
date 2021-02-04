//
//  CustomTableDetailCell.swift
//  LoginForm
//
//  Created by Вадим Куйда on 04.02.2021.
//

import UIKit
import SwiftUI

class CustomTableDetailCell: UITableViewCell {
        


    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStep: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageValid: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.addGradientBackground(firstColor: .white , secondColor: .blue)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        // Configure the view for the selected state
    }
    
}
