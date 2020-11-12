//
//  cellForm.swift
//  LoginForm
//
//  Created by Вадим Куйда on 03.11.2020.
//


import UIKit


class TableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var textTopic: UILabel!
    
    @IBOutlet weak var timeTopic: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // label.textColor = UIColor.green
        // Configure the view for the selected state
    }

    
}
