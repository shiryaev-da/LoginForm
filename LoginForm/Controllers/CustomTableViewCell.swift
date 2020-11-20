//
//  CustomTableViewCell.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelNme: UILabel!


    @IBOutlet weak var labelCount: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
