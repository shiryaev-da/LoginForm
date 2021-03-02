//
//  ViewController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 21.10.2020.
//

import UIKit
import LocalAuthentication
import CoreData



class ViewController: UIViewController {
 //Биометрий



    
    var contextIdent = LAContext()
    enum AuthenticationState {
        case loggedin, loggedout, loggedHand, loggedYes
    }
    
    var state = AuthenticationState.loggedout {
        didSet {
            print("LoginBIO")
        }
    }
    
    
    func biometricType() -> String {
      let _ = contextIdent.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      switch contextIdent.biometryType {
      case .none:
        return "textformat.123"
      case .touchID:
        return "touchid"
      case .faceID:
        return "faceid"
      }
    }

    @IBOutlet weak var buttonLogin: UIButton!
    var loginManager = LoginManager()
    let resetCoredata: Bool = true
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let delegateApp = UIApplication.shared.delegate as! AppDelegate




    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemTimeArray = [Login]()
    //Загрузка в массив
    func loadItems() {
        let request : NSFetchRequest<Login> = Login.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func typeAction(user: String, pass: String) {
        let newItem = Login(context: self.context)
        newItem.user = user
        newItem.pass = pass
        self.itemTimeArray.append(newItem)
        self.saveItems()
    }
    
    
    func saveItems() {
              
              do {
                  try context.save()
                   print("Информация сохранена")
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
    }
    
    
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
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
        spinner.color = .white
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
//        buttonLogin.setTitle("Вход", for: .normal)

    }
 

    override func viewDidLoad() {
        super.viewDidLoad()
        loginManager.delegate = self
        self.view.addGradientBackground(firstColor: UIColor(hexString: "#dfebfe"), secondColor: UIColor(hexString: "#ffffff"))
        contextIdent.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        loadItems()
        
        
        
        if itemTimeArray.count == 0  {
            state = .loggedout
            buttonLogin.setTitle("Вход", for: .normal)
        } else {
            
            if itemTimeArray[0].pass!.count < 30 {
                state = .loggedYes
                let icon = UIImage(systemName: biometricType())!

    //            buttonLogin.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                buttonLogin.setTitle("", for: .normal)
                buttonLogin.setImage(icon, for: .normal)
                buttonLogin.tintColor = .white
                let user = itemTimeArray[0].user
                let pass = itemTimeArray[0].pass!.sha512
                self.deleteAllData(entity: "Login")
                self.typeAction(user: user!, pass: pass)
                loginManager.performLogin(loginRegLet: user!, passRegLet: pass)
            } else {
            
            state = .loggedYes
            let icon = UIImage(systemName: biometricType())!

//            buttonLogin.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            buttonLogin.setTitle("", for: .normal)
            buttonLogin.setImage(icon, for: .normal)
            buttonLogin.tintColor = .white
//            buttonLogin.image(for: )
            loginManager.performLogin(loginRegLet: itemTimeArray[0].user!, passRegLet: itemTimeArray[0].pass!)
            }
        }
        
  
     
        
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
        let passRegLet = fieldPass.text!.sha512
//        print(fieldPass.text!.sha512)
        view.endEditing(true)
//        print(delegateApp.divToken)
        if (delegateApp.divToken != nil) {
        loginManager.performAddDev(loginLet: loginRegLet, id: delegateApp.divToken)
        }
        
        if itemTimeArray.count == 0  {
            state = .loggedout
            loginManager.performLogin(loginRegLet: loginRegLet, passRegLet: passRegLet)
        } else {
            state = .loggedYes
            loginManager.performLogin(loginRegLet: itemTimeArray[0].user!, passRegLet: itemTimeArray[0].pass!)
        }
        
        
    }
    
    
    
}

extension ViewController: LoginManagerDelegate {
    func didAddDev(_ Login: LoginManager, login: FlagAdd) {
        
    }
    
    func didUpdateLogin(_ Login: LoginManager, login: LoginModel) {
        
        func openMainController() {
            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {

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
        }
        
        func mainIdetn() {
            self.contextIdent = LAContext()

            self.contextIdent.localizedCancelTitle = "Ввести логин и пароль"

            // First check if we have the needed hardware support.
            var error: NSError?
            if self.contextIdent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                let reason = "Войти в учетную запись"
                self.contextIdent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                    if success {

                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
//                            self.state = .loggedHand
                            openMainController()

                        }

                    } else {
                        print(error?.localizedDescription ?? "Failed to authenticate")
                        self.state = .loggedHand
                        // Fall back to a asking for username and password.
                        // ...
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Can't evaluate policy")
                self.state = .loggedHand
                // Fall back to a asking for username and password.
                // ...
            }
        }
        
        DispatchQueue.main.async { [self] in
            self.removeLoadingScreen()
//            print(login.status)
//            self.name = login.firstName
            
            if (login.status) == 1 {

                if self.state == .loggedout {
                    self.typeAction(user: self.fieldLogin.text!, pass: self.fieldPass.text!.sha512)
                    mainIdetn()
                }
                else if self.state == .loggedYes {
                    mainIdetn()
                }
                else if self.state ==  .loggedHand {
                    self.deleteAllData(entity: "Login")
                    self.typeAction(user: self.fieldLogin.text!, pass: self.fieldPass.text!.sha512)
                    openMainController()
                }

               
                
                
                
            } else {
                let alert = UIAlertController(title: "Информация", message: "Проверьте логин/пароль", preferredStyle: UIAlertController.Style.alert)
                buttonLogin.setTitle("Вход", for: .normal)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

}

