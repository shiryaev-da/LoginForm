//
//  ViewController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import UIKit


class ViewController: UIViewController {

    
    var loginManager = LoginManager()
    let resetCoredata: Bool = true
 

    override func viewDidLoad() {
        super.viewDidLoad()
        loginManager.delegate = self
        self.view.addGradientBackground(firstColor: UIColor(hexString: "#dfebfe"), secondColor: UIColor(hexString: "#ffffff"))
  
        
    }

    @IBAction func goToReg(_ sender: Any) {
        if let newViewController = storyboard?.instantiateViewController(withIdentifier: "Reg") {
            newViewController.modalTransitionStyle = .crossDissolve // это значение можно менять для разных видов анимации появления
            newViewController.modalPresentationStyle = .overFullScreen
            present(newViewController, animated: true, completion: nil)
           }
    }
    
    
    @IBOutlet weak var fieldPass: UITextField!
    @IBOutlet weak var fieldLogin: UITextField!
    
    @IBAction func buttonLogin(_ sender: Any) {
        let loginRegLet = fieldLogin.text!
        let passRegLet = fieldPass.text!
        
        loginManager.performLogin(loginRegLet: loginRegLet, passRegLet: passRegLet)
    }
}

extension ViewController: LoginManagerDelegate {
    func didUpdateLogin(_ Login: LoginManager, login: LoginModel) {
        DispatchQueue.main.async {
            print(login.status)
//            self.name = login.firstName
            
            if (login.status) == 1 {

                if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {

//                    newViewController.modalTransitionStyle = .crossDissolve // это значение можно менять для разных видов анимации появления
//                    newViewController.modalPresentationStyle = .overFullScreen
//                    let newViewController = UINavigationController(rootViewController: tableController)
                    newViewController.firstName = login.firstName
                    newViewController.user = login.login
                    newViewController.group = login.group
                    newViewController.resetCoredata = true
                    
                    
                    let navController = UINavigationController(rootViewController: newViewController)
                    navController.modalTransitionStyle = .flipHorizontal
                    navController.modalPresentationStyle = .overFullScreen
                    
        //            newViewController.modalPresentationStyle = .currentContext
        //            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
                    self.present(navController, animated: true, completion: nil)
                   }
                
                
                
                
            } else {
                let alert = UIAlertController(title: "Информация", message: "Проверьте логин/пароль", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

}
