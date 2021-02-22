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
    
    let spinner = UIActivityIndicatorView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.addGradientBackground(firstColor: .white , secondColor: .blue)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        // Configure the view for the selected state
    }
    
    
    @objc func updateFlag(flag: UIImage) {
//        imageValid.isHidden = false
        imageValid.image = UIImage(systemName: "")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: 0, y: 0, width: 48, height: 20)
        spinner.startAnimating()

        // Adds text and spinner to the view
        imageValid.addSubview(spinner)
  
    }
    
    
    
    
    
}
