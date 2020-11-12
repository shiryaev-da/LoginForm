//
//  tableController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 03.11.2020.
//

import Foundation
import UIKit


class tableController: UITableViewController {

    
    
    @IBOutlet var tableView1: UITableView!
    
    
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
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = message.TOPIC_NAME
       return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
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
                  
                   
//                   let newItem = Exercise(context: self.context)
//                   newItem.name = textField.text!
//                   newItem.perentGroupExercise = self.selectidGroup
//                    print("Добалвен элемент\(self.selectidGroup!)")
//                   self.itemExersiceArray.append(newItem)
//                   //save data
//                   self.saveItems()
//                  // self.saveItems()

        
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
        self.contentManager.performLogin(user: self.user)
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



