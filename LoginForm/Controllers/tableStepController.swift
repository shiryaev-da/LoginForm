//
//  tableStepController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import UserNotifications

struct Record : Encodable {

}


class tableStepController: UITableViewController {
    var TOPIC_NAME: String!
    var idTopic: Int!
    var user: String!
    var group: Int!
    var contentStepManager = ContentStepManager()
    var content: [TopicStep] = []
    var contentFix: [TopicStep] = []
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
    let resetCoredata: Bool = false
    var valueSearchStep: String!
    var timeDeltaSumVar: Int = 0
    var countStepSumVar: Int!
    var idStepPlay: Int!
    var delRow: Int = 0
    var countSubRow: Int!
    var numberOfRows: [IndexPath] = []
    
    
    var numberOfRowsMain: [IndexPath] = []
    
    let loadingView = UIView()
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    
    
    

    //Градиент пробую добавить
    class Colors {
        var gl:CAGradientLayer!

        init() {
            let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor

            self.gl = CAGradientLayer()
            self.gl.colors = [colorTop, colorBottom]
            self.gl.locations = [0.0, 1.0]
        }
    }
    let colors = Colors()
    
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        let color1 = UIColor(hexString: "#dfebfe")
        let color2 = UIColor(hexString: "#ffffff")
        layer.colors = [
                        //UIColor.white.cgColor,
            color1.cgColor,  //?? UIColor.white.cgColor,
            color2.cgColor  //?? UIColor.white.cgColor
                        ]
        
        return layer
    }
    
    func refreshColor() {
        
//            view.backgroundColor = UIColor.clearColor()
//            var backgroundLayer = colors.gl
//            backgroundLayer.frame = view.frame
//            view.layer.insertSublayer(backgroundLayer, atIndex: 0)
          }

    
    //END градиент функции
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //self.view.addGradientBackground(firstColor: UIColor(hexString: "#dfebfe"), secondColor: UIColor(hexString: "#ffffff"))

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
//        content.append(contentsOf: [TopicStep(id: 216, TOPIC_ID: 296, STEP_NAME: "Презентация по продукту ")])
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        setLoadingScreen()
        loadItems()

        if activeFlag == false {
            activeID = sercheActive(searchValue: idTopic)
        } else {
            contentStepManager.performActive(loginLet: user)
        }
        
       
    }
    
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Загрузка..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        

        tableView.addSubview(loadingView)

    }
    

    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
    
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
        
        
//        print(newItem)
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
    }
    
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
//                    print(jsonString)
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
        if let i = itemTimeArray.lastIndex(where: {$0.flagActive == 0 && $0.stepID == Int16(searchValue) && $0.user == user }) {
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
    
    
    func timeDeltaSum(value searchValue: Int) -> Int {
//
        self.timeDeltaSumVar = 0
        
        self.itemTimeArray.forEach({ book in
//            print(book.topicID)
            if (book.stepID == searchValue && book.flagActive == 0 && book.typeAction == "Finish") {
                let dateStartInt = book.dateTimeStart?.timeIntervalSince1970
                let dateEndInt = book.dateTimeEnd?.timeIntervalSince1970
                self.timeDeltaSumVar = self.timeDeltaSumVar + (Int(dateEndInt ?? 0) - Int(dateStartInt ?? 0))
            }
        })
//        print (self.timeDeltaSumVar)
        return self.timeDeltaSumVar
        
    }
    
    
    func countStepSum(value searchValue: Int) -> Int {
//
        
        self.countStepSumVar = 0
        
        self.itemTimeArray.forEach({ book in
//            print(book.topicID)
            if (book.stepID == searchValue && book.flagActive == 0) {

                self.countStepSumVar = self.countStepSumVar + 1
//                self.content.append(contentsOf: [TopicStep(id: 217, TOPIC_ID: 296, STEP_NAME: "Заполнение анкеты")])
                
//                print(content)
                
            }
        })

//        self.tableView.reloadData()

        return self.countStepSumVar
        
    }
    
    
    func upadteFlagAction (stepID: Int) {
        self.itemTimeArray.forEach({ book in
//            print(book.topicID)
            if (book.stepID == stepID && book.flagActive == 0 && book.user == user) {
//                book.flagActive = 1
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
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    


    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (contentFix.count > 0) {
            self.removeLoadingScreen()
        }
        
//        if !contentFix[section].isExp {
//            return contentFix.count - self.delRow
//        } else {
//            return contentFix.count + self.delRow
//        }

        return contentFix.count + self.delRow
        
    }

    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return content.count
//
//
//    }
//
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var popup:UIView!
//        popup = UIView()
//        popup.backgroundColor = UIColor.white
//        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
//        lb.text = content[section].STEP_NAME
//        lb.font = lb.font.withSize(20)
//        lb.textAlignment = .cente
//        popup.addSubview(lb)
//        let imageOpen = UIImage(systemName: "chevron.down") as UIImage?
//        let imageClose = UIImage(systemName: "chevron.backward") as UIImage?
//        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
////        let isExpanded = filteredData[section].isExt
//        button.frame = CGRect(x: 0, y: 10, width: view.frame.size.width * 1.9, height: 20)
//        button.setImage(/*isExpanded ? imageClose : */imageOpen, for: .normal)
////        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
////        button .setBackgroundImage(image, forState: UIControlState.Normal)
////        let botton = UIButton(type: .system )
//
////        botton.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
////        botton.title(for: .selected)
////        botton.setTitleColor(.black, for: .normal)
////        botton.setTitle("Close", for: .normal)
////        botton.setImage(UIImage(systemName: "search"), for: .normal)
////        botton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
//        button.tag = section
//        popup.addSubview(button)
//        self.view.addSubview(popup)
//        return popup
//    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
 //Радиус cell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        //cell.backgroundView?.addGradientBackground(firstColor: .blue, secondColor: .darkGray)
        //cell.selectedBackgroundView?.addGradientBackground(firstColor: .blue, secondColor: .darkGray)
       // cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
        
        cell.labelNme.text = contentFix[indexPath.row].STEP_NAME
        cell.labelCount.text = String(countSecond)
//        cell.labelCount.isHidden = true
//        cell.labelComment.isHidden = true
//        cell.labelTimeAVDStep.isHidden = true
//        cell.labelTimeAVDAct.isHidden = true
        cell.labelCountStep.isHidden = true
        cell.labelCountAct.isHidden = true
        cell.buttonInfo.isHidden = true
        var idStepViz = contentFix[indexPath.row].id
         let data = timeDelta(value: idStepViz)
        let dataSum = timeDeltaSum(value: idStepViz)
        let dataCount = String(countStepSum(value: idStepViz))
        cell.labelTimeAVDAct.text =  "Время: \(castTime(localTimeDelta: dataSum))"
        //  cell.labelTimeAVDAct.text =  "Посл. шаг: \(castTime(localTimeDelta: data))"
        cell.labelTimeAVDStep.text = "Посл. шаг: \(castTime(localTimeDelta: data))"
        cell.labelCount.text = "Кол-во: \(dataCount)"
//        idStepViz = 0
//        var popup:UIView!
//        popup = UIView()
//        let imageOpen = UIImage(systemName: "chevron.down") as UIImage?
//        let imageClose = UIImage(systemName: "chevron.backward") as UIImage?
//        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
//        button.frame = CGRect(x: 0, y: 10, width: view.frame.size.width * 1.9, height: 20)
//        button.setImage(imageOpen, for: .normal)
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
//        button.tag = 0
//        print(indexPath)
//        cell.addSubview(button)
        return cell
    }
//
//    @objc func handleOpenClose(button: UIButton) {
//        print(button.tag)
//
//        let idStepViz = contentFix[button.tag].id
//        self.delRow = 0
//        let dataCount = countStepSum(value: idStepViz)
//        var indexPaths = [IndexPath]()
//        for int in button.tag...dataCount-1 {
////            var indexPaths = [IndexPath]()
////        for row in content.indices {
////            var x = x + 1
//            print(button.tag)
//            let indexPath = IndexPath(row: button.tag+int+1, section: 0)
//            print(indexPath)
//            indexPaths.append(indexPath)
//            self.delRow = self.delRow + 1
////        }
//        }
//
////        let isExpanded = contentFix[button.tag].isExp
//        contentFix[button.tag].isExp = !isExpanded
//        print(indexPaths)
//        print(self.delRow)
////        print(indexPaths)
//
//        if  isExpanded {
//            self.delRow = self.delRow * -1
//            tableView.deleteRows(at: indexPaths, with: .fade)
//
//        } else {
//            self.delRow = 0
//            tableView.insertRows(at: indexPaths, with: .fade)
//
//        }
//
//
////
//    }
    
//    @objc func adjustForKeyboard(notification: Notification) {
//        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        let keyboardScreenEndFrame = keyboardValue.cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            tableView.contentInset = .zero
//        } else {
//            tableView.contentInset = UIEdgeInsets(top: keyboardViewEndFrame.maxX, left: 0, bottom: tableView.bounds.width, right: 0)
//        }
//
//        tableView.scrollIndicatorInsets = tableView.contentInset
//
////        let selectedRange = tableView.selectedRange
////        tableView.scrollRangeToVisible(selectedRange)
//    }


    
   //MARK: Действие на нажатие
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let message = content[indexPath.row]

        let dataCount = countStepSum(value: message.id)
        
        
        

        if dataCount == 0 {
//            let alertController = UIAlertController(title: "Информация", message: "Нет ни одного замера", preferredStyle: .alert)
//            let yesAction = UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
//                    print("The user is okay.")
//                }
//            let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
//                    print("The user is not okay.")
//                }
//                alertController.addAction(yesAction)
//            self.present(alertController, animated: true, completion: nil)
            self.showToast(message: "Комментарий недоступен", font: .systemFont(ofSize: 17.0))
        }
        else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "commentStepId") as! commentStep

            newViewController.stepId = message.id
            newViewController.stepName = message.STEP_NAME
                    self.present(newViewController, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    

    @objc public func textFieldDidChange() {
        self.numberOfRows = tableView.indexPathsForSelectedRows!
        self.numberOfRows.forEach { numberOfRows in
            self.tableView.selectRow(at: numberOfRows, animated: true, scrollPosition: .top)
        }
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
        let testAction = UIContextualAction(style: .destructive, title: "") { [self] (_, _, completionHandler) in
            
           
            self.upadteFlagAction(stepID: self.contentFix[indexPath.row].id)
            self.indexRow = -1
            completionHandler(true)
            
            let topic_id = self.contentFix[indexPath.row].TOPIC_ID
            let step_id = self.contentFix[indexPath.row].id
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            self.upadteFlagAction(stepID: step_id)
            self.typeAction(nameAction: "Start", topicID: topic_id, stepID: step_id, activeID: self.activeID )
            self.timer.invalidate()
  
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//            timeDeltaSum(value: indexPath.row)
            self.idStepPlay = self.contentFix[indexPath.row].id
            self.indexRow = indexPath.row
//            self.tableView.reloadData()
//            content.append(contentsOf: [TopicStep(id: 216, TOPIC_ID: 296, STEP_NAME: "Презентация по продукту ")])
//            print(content)
//            self.tableView.reloadData()
  
            
        }
//        testAction.backgroundColor = UIColor(red: 109.0 / 255.0, green: 220.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
        testAction.backgroundColor = .systemGreen
        testAction.image = UIImage(systemName: "forward.fill")

        return UISwipeActionsConfiguration(actions: [testAction])
    }
    

    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stopAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in

            
            completionHandler(true)

//            let topic_id = self.content[indexPath.row].TOPIC_ID
//            let step_id = self.content[indexPath.row].id
            self.timer.invalidate()
            self.stopUpdateLocal()
            self.saveItems()
//            self.tableView.reloadData()
           
//            self.typeAction(nameAction: "Stop", topicID: topic_id, stepID: step_id )


        }
//        stopAction.backgroundColor = UIColor(red: 231.0 / 255.0, green: 230.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
        stopAction.backgroundColor = .systemYellow
        stopAction.image = UIImage(systemName: "pause")
        
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

    
        let alertController = UIAlertController(title: "Выход", message: "Выйти из замера?", preferredStyle: .alert)

            // Initialize Actions
        let yesAction = UIAlertAction(title: "Да", style: .destructive) { (action) -> Void in
                print("The user is okay.")
            
            if (self.idStepIn != nil) {
                self.startUpdate(value: self.idStepIn)
            }
            self.saveItems()
            let jsonTo = self.convertToJSONArray(moArray: self.itemTimeArray)
            let jsonString = self.convertIntoJSONString(arrayObject: jsonTo)!
            self.stepManager.performRequest(loginRegLet: self.user, json: jsonString)
            self.timer.invalidate()
            
            }

        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

            // Add Actions
            alertController.addAction(yesAction)
            alertController.addAction(noAction)


            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
        
        
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

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {

            self.content = content
            self.contentFix = content

//            for x in 0...content.count-1 {
//                self.countSubRow = 1
//                print(content[x].id)
//                self.contentFix.append(contentsOf: [TopicStepFix(id: content[x].id, TOPIC_ID: content[x].TOPIC_ID , STEP_NAME: content[x].STEP_NAME, isExp: true)])

//                self.itemTimeArray.forEach({ book in
//        //            print(book.topicID)
//
//                    if (book.stepID == content[x].id && book.flagActive == 0 && book.typeAction == "Finish") {
//
//                        self.contentFix.append(contentsOf: [TopicStepFix(id: content[x].id, TOPIC_ID: content[x].TOPIC_ID , STEP_NAME: String(self.countSubRow)  + content[x].STEP_NAME, isExp: true)])
//                        self.countSubRow = self.countSubRow + 1
////                        self.countStepSumVar = self.countStepSumVar + 1
//        //                self.content.append(contentsOf: [TopicStep(id: 217, TOPIC_ID: 296, STEP_NAME: "Заполнение анкеты")])
//                    }
//                })
//
//            }
        
            self.tableView.reloadData()
            self.tableView.separatorStyle = .singleLine
            self.removeLoadingScreen()
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
            cell.updateTimeAll(deltaTime: timeDeltaSum(value: self.idStepIn) , localTime: localTime)
            cell.updateCountStep(count: countStepSum(value: self.idStepIn))
    //Радиус cell
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 16
            cell.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
//              print(indexPath.row)
          }
        }
    
}


extension tableStepController: StepManagerDelegate {
    func didPostStep(_ weatherRegister: StepManager, register: StepModel) {
        DispatchQueue.main.async {
            
            
            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Table") as? tableController {
                newViewController.user = self.user
                newViewController.group = self.group
                newViewController.resetCoredata = self.resetCoredata
                newViewController.numberOfRows = self.numberOfRowsMain
                newViewController.valueSearch = self.valueSearchStep
                let navController = UINavigationController(rootViewController: newViewController)
                navController.modalTransitionStyle = .crossDissolve
                navController.modalPresentationStyle = .overFullScreen
                self.present(navController, animated: true, completion: nil)
               }
        }
        
        
    }
    
    
}

//MARK -- Color gradient


extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 105, y: self.view.bounds.maxY-70, width: 250, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 1.1, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
