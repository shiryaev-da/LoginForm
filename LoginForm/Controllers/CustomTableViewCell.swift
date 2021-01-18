//
//  CustomTableViewCell.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import UIKit
import SwiftUI


class CustomTableViewCell: UITableViewCell {
    

    

    
    @IBOutlet weak var labelNme: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    var countSecond = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        // Configure the view for the selected state
    }
    
    
    @objc func updateTime(localTime: Date) {
//        countSecond = 0
        let localTimeInt =  localTime.timeIntervalSince1970
       
        let localTimeDelta = Int(Date().timeIntervalSince1970) - Int(localTimeInt)
        print(localTimeDelta)
//        self.tableView.reloadData()
        
        
   
        
        let hours = Int(localTimeDelta) / 3600
        let minutes = Int(localTimeDelta) / 60 % 60
        let seconds = Int(localTimeDelta) % 60
        
        var times: [String] = []
        if hours > 0 {
            times.append("\(hours) Час")
          }
          if minutes > 0 {
            times.append("\(minutes) мин")
          }
          times.append("\(seconds) сек")
        
        labelCount.text = times.joined(separator: " ")
        
//        labelCount.backgroundColor = UIColor.brown
        
        
//        labelCount.text = String(localTimeDelta)
      }
    

    

}

