//
//  loginController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import Foundation
import UIKit

class loginController: UIViewController {

    
    
    @IBOutlet weak var labelHello: UILabel!
    
    
    var contentManager = ContentManager()
    let itemArray = ["1", "2", "3"]
    
    

    var loginManager = LoginManager()
    var firstName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelHello.text =  "Привет \(String(firstName))!!!"
        contentManager.delegate = self
    }
    

    

    @IBAction func clickButton(_ sender: Any) {

        
        
    }
    
    @IBAction func backSwitch(_ sender: Any) {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") {
            newViewController.modalTransitionStyle = .crossDissolve // это значение можно менять для разных видов анимации появления
            newViewController.modalPresentationStyle = .overFullScreen
//            newViewController.modalPresentationStyle = .currentContext
//            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
            self.present(newViewController, animated: true, completion: nil)

           }
    }
}
extension loginController: ContentManagerDelegate {
    func didDelTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didAddTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didContentData(_ Content: ContentManager, content: [Topic]) {
//        print(content.TOPIC_NAME)
    }
    
    
    
    
}
