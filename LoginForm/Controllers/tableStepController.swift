//
//  tableStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation
import UIKit

class tableStepController: UITableViewController {
    var TOPIC_NAME: String!
    var idStep: Int!
    var user: String!
    var group: Int!
    var contentStepManager = ContentStepManager()
    var content: [TopicStep] = []
    var timer: Timer?
    var taskList: [Task] = []
    var textCell: String!
    let vw = UIView()
    

     
    
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
        let rightBackButton1 = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "stop"),
            style: .plain,
            target: self,
            action: #selector(didRunTime)
        )
        let leftBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "arrow.backward.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        self.navigationItem.rightBarButtonItems = [rightBackButton1,rightBackButton]
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.registerTableViewCells()
        contentStepManager.delegate = self
        contentStepManager.performLogin(user: self.idStep)
        self.tableView.dataSource = self
        self.tableView.delegate = self

//        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
//        footer.backgroundColor = .brown
//        tableView.tableFooterView = footer
//        footer.isHidden = true
        
        
    }

//    @IBOutlet weak var viewNaw: UIView!
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        vw.isHidden = true
        return vw
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }


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
        cell.labelCount.text = "nil"
//        cell.labelCount.isHidden = true
      
        
//        cell.runTimeButton.isHidden = true
        return cell
        
    }
   //MARK: Действие на нажатие
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.tableFooterView?.isHidden = false
        vw.isHidden = false
        let titleLabel = UILabel(frame: CGRect(x:0, y: 0 ,width: tableView.bounds.width ,height:150))
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = .brown
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        titleLabel.text = content[indexPath.row].STEP_NAME
      
        
//        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width/3, height: 44))
//        self.view.addSubview(btn)
//        btn.setTitle("My button", for: .normal)
////        btn.backgroundColor = UIColor.blue
//        btn.setImage(UIImage(systemName: "checkmark.circle.fill"),
//                        for: [.highlighted, .selected])
     
//        btn.layer.cornerRadius = 44/2
        





        vw.addSubview(titleLabel)
//        vw.addSubview(btn)

    }
    
    @objc public func someButtonAction() {
        print("Button is tapped")
    }
    
    @objc public func didRunTime() {
        

        timer?.invalidate()
        

        
    }
    
    


    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "runleft") { (_, _, completionHandler) in

            
            completionHandler(true)
            
            


        }
        testAction.backgroundColor = .clear
        testAction.image = UIImage(systemName: "play")

        return UISwipeActionsConfiguration(actions: [testAction])
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "runright") { (_, _, completionHandler) in

            
            completionHandler(true)

            


        }
        testAction.backgroundColor = .darkGray
        testAction.image = UIImage(systemName: "stop")

        return UISwipeActionsConfiguration(actions: [testAction])
    }


    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {
            
            newViewController.user = user
            newViewController.group = group
            
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
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
                let nameTopic = textField.text
                self.contentStepManager.performAddTopicStep(groupLet: self.idStep, nameStep: nameTopic!)
                sleep(1)
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

extension tableStepController {

}
