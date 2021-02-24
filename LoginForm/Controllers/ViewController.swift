//
//  ViewController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import UIKit
import LocalAuthentication




class ViewController: UIViewController {

    
    @IBOutlet weak var buttonLogin: UIButton!
    var loginManager = LoginManager()
    let resetCoredata: Bool = true
    
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    let delegateApp = UIApplication.shared.delegate as! AppDelegate
//    let deviceToken = delegateApp.divToken

    let context = LAContext()
    
    class BiometricIDAuth {
      
    }
    
    func canEvaluatePolicy() -> Bool {
      return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    let touchMe = BiometricIDAuth()
    
    
    enum BiometricType {
      case none
      case touchID
      case faceID
    }
    
    
    func biometricType() -> BiometricType {
      let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      switch context.biometryType {
      case .none:
        return .none
      case .touchID:
        return .touchID
      case .faceID:
        return .faceID
      @unknown default:
        fatalError()
      }
    }
    
    
    
    
    var loginReason = "Logging in with Touch ID"
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        
      guard canEvaluatePolicy() else {
        completion("Touch ID not available")
        return
      }
        
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
        localizedReason: loginReason) { (success, evaluateError) in
          if success {
            DispatchQueue.main.async {
              completion(nil)
            }
          } else {
                                  
            let message: String
                                  
            switch evaluateError {
            case LAError.authenticationFailed?:
              message = "There was a problem verifying your identity."
            case LAError.userCancel?:
              message = "You pressed cancel."
            case LAError.userFallback?:
              message = "You pressed password."
            case LAError.biometryNotAvailable?:
              message = "Face ID/Touch ID is not available."
            case LAError.biometryNotEnrolled?:
              message = "Face ID/Touch ID is not set up."
            case LAError.biometryLockout?:
              message = "Face ID/Touch ID is locked."
            default:
              message = "Face ID/Touch ID may not be configured"
            }
              
            completion(message)
          }
      }
    }
    



    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner

        let x = (buttonLogin.frame.width / 2)
        let y = (buttonLogin.frame.height / 2)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: x, y: y, width: 0, height: 0)
        spinner.startAnimating()
        buttonLogin.setTitle("", for: .normal)
        // Adds text and spinner to the view
        buttonLogin.addSubview(spinner)
//        loadingView.addSubview(loadingLabel)

//        buttonLogin.addSubview(loadingView)

    }

    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        buttonLogin.setTitle("Вход", for: .normal)

    }
 

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
        
        setLoadingScreen()
        
        let loginRegLet = fieldLogin.text!
        let passRegLet = fieldPass.text!
        print(delegateApp.divToken)
        if (delegateApp.divToken != nil) {
        loginManager.performAddDev(loginLet: loginRegLet, id: delegateApp.divToken)
        }
        loginManager.performLogin(loginRegLet: loginRegLet, passRegLet: passRegLet)
    }
}

extension ViewController: LoginManagerDelegate {
    func didAddDev(_ Login: LoginManager, login: FlagAdd) {
        
    }
    
    func didUpdateLogin(_ Login: LoginManager, login: LoginModel) {
        DispatchQueue.main.async {
            self.removeLoadingScreen()
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

