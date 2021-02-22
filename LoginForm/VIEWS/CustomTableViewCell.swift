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
    @IBOutlet weak var labelCountAct: UILabel!
    @IBOutlet weak var labelCountStep: UILabel!
    @IBOutlet weak var labelTimeAVDAct: UILabel!
    @IBOutlet weak var labelTimeAVDStep: UILabel!
    @IBOutlet weak var buttonInfo: UIButton!
    
    var countSecond = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.addGradientBackground(firstColor: .white , secondColor: .blue)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        // Configure the view for the selected state
    }
    
//    class Colors {
//        var gl:CAGradientLayer!
//
//        init() {
//            let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
//            let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
//
//            self.gl = CAGradientLayer()
//            self.gl.colors = [colorTop, colorBottom]
//            self.gl.locations = [0.0, 1.0]
//        }
//    }
    
    
    
    @objc func updateTime(localTime: Date) {
//        countSecond = 0
        let localTimeInt =  localTime.timeIntervalSince1970
       
        let localTimeDelta = Int(Date().timeIntervalSince1970) - Int(localTimeInt)
   
        
        let hours = Int(localTimeDelta) / 3600
        let minutes = Int(localTimeDelta) / 60 % 60
        let seconds = Int(localTimeDelta) % 60
        
        var times: [String] = []
        if hours > 0 {
            times.append("\(hours) час")
          }
          if minutes > 0 {
            times.append("\(minutes) мин")
          }
          times.append("\(seconds) сек")
        
        labelTimeAVDStep.text = times.joined(separator: " ")
        
        
//        labelCount.backgroundColor = UIColor.brown
        
        
//        labelCount.text = String(localTimeDelta)
      }
    
    
    @objc func updateTimeAll(deltaTime: Int, localTime: Date) {
        
        let localTimeInt =  localTime.timeIntervalSince1970
       
        let localTimeDelta = Int(Date().timeIntervalSince1970) - Int(localTimeInt)
        
    
        let hours = Int(deltaTime + localTimeDelta) / 3600
        let minutes = Int(deltaTime + localTimeDelta) / 60 % 60
        let seconds = Int(deltaTime + localTimeDelta) % 60
        
        var times: [String] = []
        if hours > 0 {
            times.append("\(hours) час")
          }
          if minutes > 0 {
            times.append("\(minutes) мин")
          }
          times.append("\(seconds) сек")
        
        labelTimeAVDAct.text = times.joined(separator: " ")
    }
    
    
    @objc func updateCountStep(count: Int) {
        print(count)
        labelCount.text = "Кол-во: \(String(count ))"
    }
    

    

}

