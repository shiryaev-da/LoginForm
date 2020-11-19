//
//  CustomTableViewCell.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelNme: UILabel!

    @IBOutlet weak var labelId: UILabel!
    
    @IBAction func nextStepTopic(_ sender: Any) {
        if let text = self.labelNme.text {
            print(text)
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
