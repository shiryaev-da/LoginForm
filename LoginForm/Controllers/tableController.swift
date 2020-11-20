//
//  tableController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 03.11.2020.
//

import Foundation
import UIKit


class tableController: UITableViewController {
    var firstName: String!
    var user: String!
    var group: Int!
    var contentManager = ContentManager()
    var content: [Topic] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "Мои замеры"

        let rightBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButtonAdd)
        )
        let leftBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "arrow.backward.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        self.navigationItem.rightBarButtonItem = rightBackButton
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        labelHello.text =  "Привет \(String(firstName))!!!"
//        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.registerTableViewCells()
//        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell" )
//        let itemExersiceArray = contentManager.performLogin
//        print(contentManager.performLogin)
        contentManager.delegate = self
        contentManager.performLogin(user: user)
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    
//    func loadMessages() {
//
//
//    }
 
    
    //MARK: Замеры
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }

    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.tableView:
        
          return self.content.count
        default:
          return 0
       }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = content[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            cell.labelNme.text = message.TOPIC_NAME
        let count = String(message.COUNT_STEP)
            cell.labelCount.text = "Кол-во шагов: \(count)"
//            cell.labelId.text = String(message.id)
        
            return cell

//        cell.labelNameTopic.text = message.TOPIC_NAME
//        cell.textLabel?.text = message.TOPIC_NAME
//        cell.textLabel?.text = "1"
        
//       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let message = content[indexPath.row]
        print(message.id)
        print(message.TOPIC_NAME)
        

        
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableStep") as? tableStepController {

            newViewController.TOPIC_NAME = message.TOPIC_NAME
            newViewController.user = user
            newViewController.group = group
            newViewController.idStep = message.id
            
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .flipHorizontal
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
           }
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contentManager.performDelTopic(loginLet: self.user, groupLet: self.group, nameTopic: content[indexPath.row].TOPIC_NAME)
            content.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            print(content[indexPath.row].TOPIC_NAME)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") {
            newViewController.modalTransitionStyle = .flipHorizontal // это значение можно менять для разных видов анимации появления
            newViewController.modalPresentationStyle = .overFullScreen
//            newViewController.modalPresentationStyle = .currentContext
//            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
            self.present(newViewController, animated: true, completion: nil)

           }
    }
    
    //MARK: Кнопка Добавления
    @objc public func didTapMenuButtonAdd() {
                DispatchQueue.main.async {
        var textField = UITextField()
               
               let alert = UIAlertController (title: "Добавить действие", message: "", preferredStyle: .alert)
               let action = UIAlertAction (title: "Добавить", style: .default) { (action) in
//                   print(textField.text)
                let nameTopic = textField.text
             
                self.contentManager.performAddTopic(loginLet: self.user, groupLet: self.group, nameTopic: nameTopic!)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
         
                   
//                   let newItem = Exercise(context: self.context)
//                   newItem.name = textField.text!
//                   newItem.perentGroupExercise = self.selectidGroup
//                    print("Добалвен элемент\(self.selectidGroup!)")
//                   self.itemExersiceArray.append(newItem)
//                   //save data
//                   self.saveItems()
//                  // self.saveItems()
                self.contentManager.performLogin(user: self.user)
                self.tableView.reloadData()
        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Добавить новое действие"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
                    self.tableView.reloadData()
                    self.present(alert, animated: true, completion: nil)
  


//
//            let indexPath = IndexPath(row: self.content.count - 1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//
        }

    }
    
}

extension tableController: ContentManagerDelegate {
    func didDelTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didAddTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didContentData(_ Content: ContentManager, content: [Topic]) {
        self.content = content
        DispatchQueue.main.async {
                self.tableView.reloadData()
//                let indexPath = IndexPath(row: self.content.count - 1, section: 0)
////                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            

        }
    }
}



