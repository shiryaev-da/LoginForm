//
//  tableStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation
import UIKit

class tableStepController: UITableViewController {
    let arrayText = ["1","2","3"]
    
    var TOPIC_NAME: String!
    var idStep: Int!
    var user: String!
    var group: Int!
    var contentStepManager = ContentStepManager()
    var content: [TopicStep] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.navigationItem.title = TOPIC_NAME
        
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
        self.registerTableViewCells()
        contentStepManager.delegate = self
        contentStepManager.performLogin(user: self.idStep)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    // MARK: - Table view data source



    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return content.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.labelNme.text = content[indexPath.row].STEP_NAME
        cell.labelCount.text = nil
//            cell.labelId.text = String(message.id)
       
           return cell
    }


    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {
            
            newViewController.user = user
            newViewController.group = group
            
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .flipHorizontal
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)

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
             
                self.contentStepManager.performAddTopicStep(groupLet: self.idStep, nameStep: nameTopic!)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
         
                   
//                   let newItem = Exercise(context: self.context)
//                   newItem.name = textField.text!
//                   newItem.perentGroupExercise = self.selectidGroup
//                    print("Добалвен элемент\(self.selectidGroup!)")
//                   self.itemExersiceArray.append(newItem)
//                   //save data
//                   self.saveItems()
//                  // self.saveItems()
                self.contentStepManager.performLogin(user: self.idStep)
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


extension tableStepController: ContentStepManagerDelegate {
    func didContentStepData(_ Content: ContentStepManager, content: [TopicStep]) {
        self.content = content
        DispatchQueue.main.async {
                self.tableView.reloadData()
//                let indexPath = IndexPath(row: self.content.count - 1, section: 0)
////                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            

        }
    }
    
    func didAddTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep) {
        
    }
    
    func didDelTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep) {
        
    }
    
    
}
