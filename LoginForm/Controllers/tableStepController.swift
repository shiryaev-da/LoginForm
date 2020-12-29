//
//  tableStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation
import UIKit
import CoreData

class tableStepController: UITableViewController {
    var TOPIC_NAME: String!
    var idStep: Int!
    var user: String!
    var group: Int!
    var contentStepManager = ContentStepManager()
    var content: [TopicStep] = []
//    var timer: Timer?
    var taskList: [Task] = []
    var textCell: String!
    let vw = UIView()
    var idStepIn: Int!
    var r: Int!
    var timer = Timer()
    var countSecond = 0
    var indexRow = 0
    var localTime = Date()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemTimeArray = [Logtimer]()
    

     
    
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

        
        loadItems()
//        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
//        footer.backgroundColor = .brown
//        tableView.tableFooterView = footer
//        footer.isHidden = true
        
        
    }

//    @IBOutlet weak var viewNaw: UIView!
    
//    MARK: Timer
//
//    @objc func updateTimer() {
////        countSecond = 0
//        countSecond += 1
//        print(countSecond)
//        self.tableView.reloadData()
////        cell.labelCount.text = String(countSecond)
//      }
    //MARK: CoreDATA
    
    func typeAction(nameAction: String, topicID: Int, stepID: Int) {
        let newItem = Logtimer(context: self.context)
        newItem.dateTimeStart = Date()
        localTime = Date()
        newItem.typeAction = nameAction
        newItem.topicID = Int16(topicID)
        newItem.stepID = Int16(stepID)
        idStepIn = stepID
        
        print(newItem)
        // newItem.perentGroupExercise = self.selectidGroup
        //  print("Добалвен элемент\(self.selectidGroup!)")
        self.itemTimeArray.append(newItem)
        //save data
        self.saveItems()
        
    }
    // Сохранение
    func saveItems() {
              
              do {
                  try context.save()
                   print("Информация сохранена")
              } catch {
                print("Ошибка сохранения нового элемента замера\(error)")
              }
        //  self.tableView.reloadData()
          }
    
    
    //Загрузка в массив
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    

    // Обновление данных
    func stopUpdate(value searchValue: Int)
    {
        if let i = itemTimeArray.firstIndex(where: { $0.stepID == Int16(searchValue) && $0.dateTimeEnd == nil }) {
            print(i)
            idStepIn = i
            itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
            itemTimeArray[i].setValue("Finish", forKey: "typeAction")
        }
    }
    
    
    func startUpdate(value searchValue: Int)
    {
            if let i = itemTimeArray.firstIndex(where: { $0.stepID == Int16(searchValue) && $0.dateTimeEnd == nil }) {
                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                itemTimeArray[i].setValue("Finish", forKey: "typeAction")
        }
    }
    
    func timeDelta(value searchValue: Int) -> Int {
        r = 0
        if let i = itemTimeArray.firstIndex(where: { $0.stepID == Int16(searchValue) }) {
            let dateStartInt = itemTimeArray[i].dateTimeStart?.timeIntervalSince1970
            let dateEndInt = itemTimeArray[i].dateTimeEnd?.timeIntervalSince1970
//            let timeInterval = someDate.dateStartInt
            r = Int(dateEndInt ?? 0) - Int(dateStartInt ?? 0)
        }
        if r != nil && r > 0 {
            return r!
        } else{
            return 0
        }
    }
    
    
    //MARK: Преобразование во Время
    func castTime (localTimeDelta: Int) -> String {
    let hours = Int(localTimeDelta) / 3600
    let minutes = Int(localTimeDelta) / 60 % 60
    let seconds = Int(localTimeDelta) % 60
    
    var times: [String] = []
    if hours > 0 {
      times.append("\(hours)h")
    }
    if minutes > 0 {
      times.append("\(minutes)m")
    }
    times.append("\(seconds)s")
    
    return times.joined(separator: " ")
    }
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
        cell.labelCount.text = String(countSecond)
//        cell.labelCount.isHidden = true
//        cell.labelComment.isHidden = true
        var idStepViz = content[indexPath.row].id
         let data = timeDelta(value: idStepViz)
        cell.labelComment.text =  castTime(localTimeDelta: data)
        idStepViz = 0
//        let str = String(decoding: data, as: UTF8.self)
  
        
//        cell.runTimeButton.isHidden = true
        return cell
        
    }
   //MARK: Действие на нажатие
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
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
        

      
//        let index = find(value: "Eddie", in: itemTimeArray)
//        print(index)
       
        self.saveItems()
        
//        itemTimeArray[0].setValue("43", forKey: "stepID")
        
//        self.saveItems()
        
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
        


        

        
    }
    
    


    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "Старт") { (_, _, completionHandler) in

            self.indexRow = -1
            completionHandler(true)
            
            let topic_id = self.content[indexPath.row].TOPIC_ID
            let step_id = self.content[indexPath.row].id
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            self.typeAction(nameAction: "Start", topicID: topic_id, stepID: step_id )
            self.timer.invalidate()
  
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)

            self.indexRow = indexPath.row
//            self.tableView.reloadData()

        }
        testAction.backgroundColor = .systemGreen
        testAction.image = UIImage(systemName: "forward.fill")

        return UISwipeActionsConfiguration(actions: [testAction])
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stopAction = UIContextualAction(style: .destructive, title: "Стоп") { (_, _, completionHandler) in

            
            completionHandler(true)

//            let topic_id = self.content[indexPath.row].TOPIC_ID
//            let step_id = self.content[indexPath.row].id
            self.timer.invalidate()
            self.stopUpdate(value: self.content[indexPath.row].id)
            self.saveItems()
            self.tableView.reloadData()
           
//            self.typeAction(nameAction: "Stop", topicID: topic_id, stepID: step_id )


        }
        stopAction.backgroundColor = .darkGray
        stopAction.image = UIImage(systemName: "stop")
        
        let editAction = UIContextualAction(style: .destructive, title: "edit") { (_, _, completionHandler) in

            
//            completionHandler(true)

//            let topic_id = self.content[indexPath.row].TOPIC_ID
//            let step_id = self.content[indexPath.row].id
//
//            self.typeAction(nameAction: "edit", topicID: topic_id, stepID: step_id )
            
            


        }
        editAction.backgroundColor = .blue
        editAction.image = UIImage(systemName: "edit")

        return UISwipeActionsConfiguration(actions: [stopAction,editAction])
    }


    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {
            
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            self.saveItems()
            
            newViewController.user = user
            newViewController.group = group
            
            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)

           }
        self.timer.invalidate()
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


// MARK: - Timer
extension tableStepController {

//    @objc func updateTimer() {
//      // 1
//      guard let visibleRowsIndexPaths = tableView.indexPathsForVisibleRows else {
//        return
//      }
//
//      for indexPath in visibleRowsIndexPaths {
//        // 2
//        if let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell {
//          cell.updateTime()
//        }
//      }
//    }
    
    
    
    
//    @objc func updateTimer() {
////       1
//      guard let visibleRowsIndexPaths = tableView.indexPathsForSelectedRows else {
//        return
//      }
//
//      for indexPath in visibleRowsIndexPaths {
//        // 2
//        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CustomTableViewCell {
//          cell.updateTime()
//            print(indexPath.row)
//        }
//      }
//    }
    
    
    @objc func updateTimer() {



//        for indexPath in visibleRowsIndexPaths {
          // 2
          if let cell = tableView.cellForRow(at: IndexPath(row: indexRow, section: 0)) as? CustomTableViewCell {
            cell.updateTime(localTime: localTime)
//              print(indexPath.row)
          }
        }
    
}
