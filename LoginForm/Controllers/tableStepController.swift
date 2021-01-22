//
//  tableStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//





    



import Foundation
import UIKit
import CoreData


struct Record : Encodable {

}


class tableStepController: UITableViewController {

    

    var TOPIC_NAME: String!
    var idTopic: Int!
    var user: String!
    var group: Int!
    var contentStepManager = ContentStepManager()
    var content: [TopicStep] = []
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
    var records = [Record]()
    var stepManager = StepManager()
    var activeID: Int!
    var activeFlag: Bool = false
    

     
    
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
        contentStepManager.performLogin(user: self.idTopic)
        stepManager.delegate = self
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        
        
        loadItems()

        if activeFlag == false {
            activeID = sercheActive(searchValue: idTopic)
        } else {
            contentStepManager.performActive(loginLet: user)
        }
    }

    //MARK: CoreDATA
    
    func typeAction(nameAction: String, topicID: Int, stepID: Int, activeID: Int) {
        
        let newItem = Logtimer(context: self.context)
        newItem.dateTimeStart = Date()
        localTime = Date()
        newItem.typeAction = nameAction
        newItem.topicID = Int16(topicID)
        newItem.stepID = Int16(stepID)
        newItem.user = user
        newItem.activeID = Int16(activeID)
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
    
    let array = [["typeAction": "Finish", "stepID": 63, "dateTimeEnd": "2021-01-18 10:49:00 +0000", "dateTimeStart": "2021-01-18 10:48:56 +0000", "flagActive": 0, "topicID": 201]]
    //Загрузка в массив
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
//            records = try context.fetch(request) as [Record]
//            let jsonData = try JSONEncoder().encode(records)

        } catch {
            print("Error")
        }
    }

    
    //MARK: CoreData --> array
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = "\(value)"
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }

    //MARK: --> array --> json
    func convertIntoJSONString(arrayObject: Any) -> String? {

            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
                if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    print(jsonString)
                    return jsonString as String
                }

            } catch let error as NSError {
                print("Array convertIntoJSON - \(error.description)")
            }
            return nil
        }
    

    // Обновление данных
    func stopUpdateLocal()
    {
        if (self.idStepIn != nil) {
            if let i = itemTimeArray.firstIndex(where: { $0.stepID == self.idStepIn && $0.dateTimeEnd == nil && $0.user == user }) {
                print(i)
                idStepIn = i
                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                itemTimeArray[i].setValue("Finish", forKey: "typeAction")
                itemTimeArray[i].setValue(0, forKey: "flagActive")
                self.saveItems()
            }
        }
    }
    
    func sercheActive(searchValue: Int) -> Int
    {

        if let i = itemTimeArray.firstIndex(where: {  $0.flagActive == 0 && $0.user == user && $0.topicID ==  Int16(searchValue)}) {
                print(i)
            activeID = Int(itemTimeArray[i].activeID)
            }
        return activeID
    }
    
    
    func startUpdate(value searchValue: Int)
    {
            if let i = itemTimeArray.firstIndex(where: { $0.stepID == Int16(searchValue) && $0.dateTimeEnd == nil && $0.user == user }) {
                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                itemTimeArray[i].setValue("Finish", forKey: "typeAction")
//                itemTimeArray[i].setValue(1, forKey: "flagActive")
                self.saveItems()
        }
    }
    
    func timeDelta(value searchValue: Int) -> Int {
        r = 0
        if let i = itemTimeArray.firstIndex(where: {$0.flagActive == 0 && $0.stepID == Int16(searchValue) && $0.user == user }) {
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
    
    func upadteFlagAction (stepID: Int) {
        self.itemTimeArray.forEach({ book in
//            print(book.topicID)
            if (book.stepID == stepID && book.flagActive == 0 && book.user == user) {
                book.flagActive = 1
                saveItems()
            }
        })
    }
    
    
    //MARK: Преобразование во Время
    func castTime (localTimeDelta: Int) -> String {
    let hours = Int(localTimeDelta) / 3600
    let minutes = Int(localTimeDelta) / 60 % 60
    let seconds = Int(localTimeDelta) % 60
    
        var times: [String] = []
        if hours > 0 {
          times.append("\(hours) Час")
        }
        if minutes > 0 {
          times.append("\(minutes) мин")
        }
        times.append("\(seconds) сек")
    
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
        cell.labelComment.isHidden = true
        var idStepViz = content[indexPath.row].id
         let data = timeDelta(value: idStepViz)
        cell.labelCount.text =  castTime(localTimeDelta: data)
        idStepViz = 0
//        let str = String(decoding: data, as: UTF8.self)
  
        
//        cell.runTimeButton.isHidden = true
        return cell
        
    }
   //MARK: Действие на нажатие
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
//        print(indexPath.row)
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
       
//        self.saveItems()
        
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
    //MARK: Кнопка Стоп
    @objc public func didRunTime() {
        stopUpdateLocal()
//        stopUpdateLocal()
        let jsonTo = convertToJSONArray(moArray: itemTimeArray)
        let jsonString = convertIntoJSONString(arrayObject: jsonTo)!
        stepManager.performRequest(loginRegLet: user, json: jsonString)
        self.timer.invalidate()
        
        let alertController = UIAlertController(title: "Данные на сервере!", message: "", preferredStyle: .alert)

            // Initialize Actions

        let noAction = UIAlertAction(title: "ok", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

            // Add Actions
        
            alertController.addAction(noAction)


            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    


    //MARK:  Действия на свайп
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let testAction = UIContextualAction(style: .destructive, title: "Старт") { (_, _, completionHandler) in
            
           
            self.upadteFlagAction(stepID: self.content[indexPath.row].id)
            
            self.indexRow = -1
            completionHandler(true)
            
            let topic_id = self.content[indexPath.row].TOPIC_ID
            let step_id = self.content[indexPath.row].id
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            self.upadteFlagAction(stepID: step_id)
            self.typeAction(nameAction: "Start", topicID: topic_id, stepID: step_id, activeID: self.activeID )
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
            self.stopUpdateLocal()
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

        return UISwipeActionsConfiguration(actions: [stopAction/*,editAction*/])
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
                self.contentStepManager.performAddTopicStep(groupLet: self.idTopic, nameStep: nameTopic!)
                sleep(1)
                self.contentStepManager.performLogin(user: self.idTopic)
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
    func didActimeTime(_ Content: ContentStepManager, content: AddActiveModel) {
        
        activeID = content.idAddActive
    }
    
    
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

//MARK: Json
extension NSManagedObject {
  func toJSON() -> String? {
    let keys = Array(self.entity.attributesByName.keys)
    let dict = self.dictionaryWithValues(forKeys: keys)
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        return reqJSONStr
    }
    catch{}
    return nil
  }

}





// MARK: - Timer
extension tableStepController {
    
    
    @objc func updateTimer() {



//        for indexPath in visibleRowsIndexPaths {
          // 2
          if let cell = tableView.cellForRow(at: IndexPath(row: indexRow, section: 0)) as? CustomTableViewCell {
            cell.updateTime(localTime: localTime)
//              print(indexPath.row)
          }
        }
    
}


extension tableStepController: StepManagerDelegate {
    func didPostStep(_ weatherRegister: StepManager, register: StepModel) {
        
    }
    
    
}
