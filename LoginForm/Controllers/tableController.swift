//
//  tableController.swift
//  LoginForm
//
//  Created by Вадим Куйда on 03.11.2020.
//

import Foundation
import UIKit
import CoreData


class SeccondViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Статистика"

    }
}


class tableController: UITableViewController, UISearchBarDelegate {
    var firstName: String!
    var user: String!
    var group: Int!
    var contentManager = ContentManager()
    var content: [Sector] = []
    var contentCore: [TopicStepCore] = []
    var itemTimeArray = [Logtimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contentActive: Int!
    var filteredData: [Sector]!
    var topicVar: [Topic]!
    var resetCoredata = true
//    var figuresByLetter = [(key: String, value: [Topic])]()
    var numberOfRows: [IndexPath] = []
    var valueSearch: String = ""
    
    let loadingView = UIView()

    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()

    /// Text shown during load the TableView
    let loadingLabel = UILabel()
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
        title = "Замеры"
        //self.tableView.backgroundColor = addGradientBackground(UIColor.white, UIColor.black)
        self.navigationItem.title = "Замеры"
        let rightBackButton = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButtonAdd)
        )
        let rightBackButton1 = UIBarButtonItem(
    //            title: "Back",
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButtonSendMail)
        )
        let leftBackButton = UIBarButtonItem(
    //            title: "Back",
//            image: UIImage(systemName: "arrow.backward.circle.fill"),
            title: "Выход",
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton))
        self.navigationItem.rightBarButtonItems = [rightBackButton, rightBackButton1]
        self.navigationItem.leftBarButtonItem = leftBackButton
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        labelHello.text =  "Привет \(String(firstName))!!!"
//        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.registerTableViewCells()
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell" )
//        let itemExersiceArray = contentManager.performLogin
//        print(contentManager.performLogin)
        contentManager.delegate = self
        contentManager.performLogin(user: user)
        contentManager.performStep(loginLet: user)
        filteredData = content
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.text = valueSearch

//        self.searchBar.isFocused
        searchBar.delegate = self
        setLoadingScreen()
        self.tableView.reloadData()
        self.tableView.keyboardDismissMode = .interactive
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.scrollsToTop = true
       loadItems()


//        showSearchBar()

    }
        
    
    
    // MARK: Ожидание загрузки



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
        spinner.style = UIActivityIndicatorView.Style.medium  //.gray
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
 
    func loadItems() {
        let request : NSFetchRequest<Logtimer> = Logtimer.fetchRequest()
        do {
            itemTimeArray = try context.fetch(request)
        } catch {
            print("Error")
        }
    }
    
    func saveItems() {
        do {
        try context.save()
        print("Информация сохранена")
        } catch {
        print("Ошибка сохранения нового элемента замера\(error)")
        }
        //  self.tableView.reloadData()
    }
    
    func sumFactCell (topicI: Int) -> Int {
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.topicID == topicI && book.flagActive == 0 && book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    func sumFactCellUser () -> Int {
        var i = 0
        self.itemTimeArray.forEach({ book in
            if (book.user == user) {
                i = i + 1
            }
        })
        return i
    }
    
    

    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    


    
    //MARK: Замеры
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }

    

    func isColorRow (numTag: Float) -> UIColor {

        switch numTag {
        case 0, 0.33:
            return UIColor(hexString: "#cd3011")
        case 0.34..<0.66:
            return UIColor(hexString: "#ff8b05")
        case 0.66..<100:
            return UIColor(hexString: "#20ab00")
        default:
            return UIColor(hexString: "#cd3011")
        }
    }
    

    

    
    
    func castTime (localTimeDelta: Int) -> String {
    let hours = Int(localTimeDelta) / 3600
    let minutes = Int(localTimeDelta) / 60 % 60
    let seconds = Int(localTimeDelta) % 60
    
        var times: [String] = []
        if hours > 0 {
          times.append("\(hours)")
        }
        if hours < 1 {
          times.append("0")
        }
        if minutes > 9 {
          times.append("\(minutes)")
        }
        if minutes >= 1 && minutes < 10 {
          times.append("0\(minutes)")
        }
        if minutes <  1 {
          times.append("00")
        }
        if seconds > 9 {
            times.append("\(seconds)")
        }
        if  seconds >= 1  && seconds < 10 {
            times.append("0\(seconds)")
        }
        if seconds < 1 {
          times.append("00")
        }
    
    return times.joined(separator: ":")
    }
    

    
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
    
        let message = filteredData[indexPath.section].topic[indexPath.row]
         let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        

        
//MARK: Принудильтельный скролл

        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 10.0
        cell.indentationWidth = 30
        cell.layer.borderColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor

        cell.backgroundColor = .white

        cell.labelNme.textColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        cell.labelNme.font = UIFont(name: "SBSansText-SemiBold", size: 15)
        cell.labelNme.text = message.TOPIC_NAME
        
        
        let count = String(message.COUNT_STEP)
//        cell.labelComment.text = message.FLD_COMMENT

        
        cell.labelCountAct.font = UIFont(name: "SBSansText-Regular", size: 14)
        cell.labelCountAct.text = "\(String(message.COUNT_ACTIVE_F)) из \(message.PLAN_COUNT) замеров "
        cell.labelCountAct.textColor = isColorRow(numTag: Float(Float(message.COUNT_ACTIVE_F)/Float(message.PLAN_COUNT)))
        
//        cell.labelCountStep.isHidden = true
//        cell.labelCountStep.text = "Шагов: \(String(message.COUNT_STEP_F))"
        
        cell.labelTimeAVDAct.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        cell.labelTimeAVDAct.font = UIFont(name: "SBSansText-Regular", size: 10)
        cell.labelTimeAVDAct.text = (castTime(localTimeDelta: Int(message.AVG_TIME_TOPIC)))
        
        cell.labelAvgString.textColor = UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        cell.labelAvgString.font = UIFont(name: "SBSansText-Regular", size: 10)
//        cell.labelAvgString.text = (castTime(localTimeDelta: Int(message.AVG_TIME_TOPIC)))
        

        
        cell.labelTimeAVDStep.textColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        cell.labelTimeAVDStep.font = UIFont(name: "SBSansText-Regular", size: 10)
        cell.labelTimeAVDStep.text = (castTime(localTimeDelta: Int(message.AVG_TIME_STEP)))
        
        
        
        cell.labelCount.textColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        cell.labelCount.font = UIFont(name: "SBSansText-Regular", size: 10)
        cell.labelCount.text = "\(String(sumFactCell(topicI: message.id))) из \(count)"

        
        
        
        cell.labelAvgStep.textColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        cell.labelAvgStep.font = UIFont(name: "SBSansText-Regular", size: 10)

        cell.labelAvg.textColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        cell.labelAvg.font = UIFont(name: "SBSansText-Regular", size: 10)

        
        cell.buttonInfo.tag = message.id
        
        
//        cell.buttonInfo.titleLabel?.isHidden = true
//        cell.buttonInfo.setImage(UIImage(systemName: "info"), for: .normal)
//        cell.buttonInfo.setImage(UIImage(systemName: "info"), for: .highlighted)
//        cell.buttonInfo.image(for: "pencil")
//        cell.buttonInfo.tag1 = indexPath.section
        cell.buttonInfo.addTarget(self, action: #selector(connected(sender:)), for: .allTouchEvents)
        cell.buttonInfo.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        

//        print(cell)
        return cell
    }
    

    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
//            let presentationController = CustomPresentationController(presentedViewController: presented, presenting: presenting, presentedViewHeight: 100)
//            return presentationController
//        }
//    
//    class CustomPresentationController: UIPresentationController {
//      var presentedViewHeight: CGFloat
//      init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentedViewHeight: CGFloat) {
//            self.presentedViewHeight = presentedViewHeight
//            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
//        }
//
//      override var frameOfPresentedViewInContainerView: CGRect {
//            var frame: CGRect = .zero
//            frame.size = CGSize(width: containerView!.bounds.width, height: presentedViewHeight)
//            frame.origin.y = containerView!.frame.height - presentedViewHeight
//            return frame
//        }
//    }

    @objc func connected(sender: UIButton){
        

        let buttonTag = sender.tag
        
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableDetal") as? tableDetailController {
        newViewController.TOPIC_NAME = "Детализация"
            newViewController.user = user
            newViewController.group = group
            newViewController.TOPIC_ID = buttonTag
       
       

        let navController = UINavigationController(rootViewController: newViewController)
//        navController.modalTransitionStyle = .crossDissolve
//        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: true, completion: nil)
        }
        
        print(buttonTag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return filteredData.count
        
   
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredData[section].isExt {
            return 0
        }
        return filteredData[section].topic.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var popup:UIView!
//

        popup = UIView()
        popup.backgroundColor = UIColor.white

        let lb = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.size.width, height: 40))
        lb.text = filteredData[section].name
//        lb.font = lb.font.withSize(20)
        lb.textColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        lb.font = UIFont(name: "SBSansText-Thin", size: 17)
        lb.textAlignment = .left
        popup.addSubview(lb)
        let imageOpen = UIImage(systemName: "chevron.backward")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let imageClose = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        let isExpanded = filteredData[section].isExt
        button.frame = CGRect(x: 0, y: 10, width: view.frame.size.width * 1.9, height: 20)
        button.setImage(isExpanded ? imageClose : imageOpen, for: .normal)
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        button.tag = section
        popup.addSubview(button)
        self.view.addSubview(popup)
        return popup
    }
    

    
    
    //MARK: Сворачивание
    @objc func handleOpenClose(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in filteredData[section].topic.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        
        let isExpanded = filteredData[section].isExt
        filteredData[section].isExt = !isExpanded
        
        let imageOpen = UIImage(systemName: "chevron.backward")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        let imageClose = UIImage(systemName: "chevron.down")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) as UIImage?
        
        button.setImage(isExpanded ? imageOpen : imageClose, for: .normal)


        
        if  isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    

       
    
    
    //MARK: Бар для поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if let searchText = searchBar.text {
                if searchText == "" {
                    filteredData = content
            }
             else {
                topicVar = []
                filteredData = []
                for item in content {
                    
//                    filteredData.append(item)
                    for x in item.topic {
                        
                        if x.TOPIC_NAME.lowercased().contains(searchText.lowercased()) {
                            topicVar.append(x)
                        }
                        
                    }

                    filteredData  = [Sector(name: "Поиск", isExt: true, topic: topicVar)]
                }
            }
            }

        
        self.valueSearch = searchText

        tableView.reloadData()
    }
    //MARK: Действие по нажатию
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)

        let message = filteredData[indexPath.section].topic[indexPath.row]
//        print(message.id)
//
//        print(message.TOPIC_NAME)


        func openCell(flagActive: Bool) {
        if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "TableStep") as? tableStepController {

//            let selectedRows = tableView.indexPathsForSelectedRows
//            print(selectedRows)
            newViewController.TOPIC_NAME = message.TOPIC_NAME
            newViewController.user = self.user
            newViewController.group = self.group
            newViewController.idTopic = message.id
            newViewController.activeFlag = flagActive
            newViewController.numberOfRowsMain = self.tableView.indexPathsForSelectedRows!
            newViewController.valueSearchStep = valueSearch

            let navController = UINavigationController(rootViewController: newViewController)
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
           }
        }
        
        func upadteFlagAction () {
            self.itemTimeArray.forEach({ book in
                print(book.topicID)
                if (book.topicID == message.id && book.flagActive == 0 && book.user == user) {
                    book.flagActive = 1
                    saveItems()
                }
            })
        }
        

        if ((sumFactCell(topicI: message.id)) != 0) {
            let alertController = UIAlertController(title: "Создать новый замер?", message: "", preferredStyle: .alert)

                // Initialize Actions
            let yesAction = UIAlertAction(title: "Да", style: .default) { (action) -> Void in
                    print("The user is okay.")
                    openCell(flagActive: true)
                    upadteFlagAction ()
                

                }

            let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                    print("The user is not okay.")
                    openCell(flagActive: false)
                }

                // Add Actions
            
                alertController.addAction(yesAction)
                alertController.addAction(noAction)
     

                // Present Alert Controller
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            openCell(flagActive: true)
        }

        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            contentManager.performDelTopic(loginLet: self.user, groupLet: self.group, nameTopic: content[indexPath.row].TOPIC_NAME)
//            content.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
////            print(content[indexPath.row].TOPIC_NAME)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
//
//    //Название кнопки удалить
//

    //MARK:  Действия на свайп
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let testAction = UIContextualAction(style: .destructive, title: "del") { (_, _, completionHandler) in
//            self.contentManager.performDelTopic(loginLet: self.user, groupLet: self.group, nameTopic: self.filteredData[indexPath.row].TOPIC_NAME)
//            self.filteredData[indexPath.section].topic.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
////            figuresByLetter[indexPath.section].value[indexPath.row]
//
//
////            completionHandler(true)
//        }
//        testAction.backgroundColor = .red
//        testAction.image = UIImage(systemName: "trash")
//        let testAction2 = UIContextualAction(style: .destructive, title: "Edit") { (_, _, completionHandler) in
//            print("test")
//            completionHandler(true)
//        }
//        testAction2.backgroundColor = .clear
//        testAction2.image = UIImage(systemName: "pencil")
//        return UISwipeActionsConfiguration(actions: [testAction])
//    }
    

    
    //MARK: Кнопка Выход
    @objc public func didTapMenuButton() {
        
        let alertController = UIAlertController(title: "Выход", message: "Выйти из учетной записи?", preferredStyle: .alert)

            // Initialize Actions
        let yesAction = UIAlertAction(title: "Выйти", style: .destructive) { (action) -> Void in
                print("The user is okay.")
            self.deleteAllData(entity: "Login")
            if let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "main") {
                newViewController.modalTransitionStyle = .flipHorizontal // это значение можно менять для разных видов анимации появления
                newViewController.modalPresentationStyle = .overFullScreen
    //            newViewController.modalPresentationStyle = .currentContext
    //            newViewController.modalPresentationStyle = .overCurrentContext // это та самая волшебная строка, убрав или закомментировав ее, вы получите появление смахиваемого контроллера
                self.present(newViewController, animated: true, completion: nil)




               }
            }

        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

            // Add Actions
        
            alertController.addAction(noAction)
            alertController.addAction(yesAction)

            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
        

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
                sleep(1)
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
  
        }

    }
    
    //MARK: Кнопка Отправки отчета
    @objc public func didTapMenuButtonSendMail() {


        
        
        let alertController = UIAlertController(title: "Информация", message: "Вы хотите отправить отчет на e-Mail?", preferredStyle: .alert)

        
        // Initialize Actions
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { (action) -> Void in
                print("The user is not okay.")
            }

        let yesAction = UIAlertAction(title: "Да", style: .cancel) { (action) -> Void in
                print("The user is okay.")
            
            let today = Date()
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "yMMd_Hmmss"

            
            
                self.contentManager.performSendMail(loginLet: self.user, keyName: self.user + "_" + formatter1.string(from: today))
                
            }


            // Add Actions
            alertController.addAction(yesAction)
            alertController.addAction(noAction)




            // Present Alert Controller
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        

    }
    
}

extension tableController: ContentManagerDelegate {
    func didSendMail(_ Content: ContentManager, content: SendMail) {
        DispatchQueue.main.async {
        print(content.mail)
        
        
        
        let alert = UIAlertController(title: "Информация", message: "Сообщение отправлено на \(content.mail)", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    

    
    
    func didContentStepDataCore(_ Content: ContentManager, content: [TopicStepCore]) {
        self.contentCore = content
        func saveContentCore() {
            
            self.contentCore.forEach({ item in
                do {
                let newItem = Logtimer(context: self.context)
                newItem.user = item.USERNAME
                newItem.stepID = Int16(item.STEPID)!
                newItem.topicID = Int16(item.TOPICID)!
                newItem.flagActive = Int16(item.FLAGACTIVE)!
                    newItem.dateTimeStart = castDate(dateOld: item.DATETIMESTART)
                    newItem.dateTimeEnd = castDate(dateOld: item.DATETIMEEND)
                    newItem.typeAction = "Finish"
                    newItem.activeID = Int16(item.ACTIVEID)
//                    print(castDate(dateOld: item.DATETIMEEND))
                try context.save()
                } catch {
                    print("failure")
                  }
            })
        }
        
        func castDate(dateOld: String) -> Date {
            let isoDate = dateOld
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from:isoDate)!
            return date
        }
        

        
//        self.content.remove(at: indexPath.row)
        
        if (resetCoredata == false ) {
//            saveContentCore()
//            loadItems()
        }else
        {
            deleteAllData(entity: "Logtimer")
            saveContentCore()
            loadItems()
        }
        
        DispatchQueue.main.async {
            self.contentManager.performLogin(user: self.user)
                self.tableView.reloadData()
//                let indexPath = IndexPath(row: self.content.count - 1, section: 0)
////                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            

        }
    }
    
    func didDelTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didAddTopic(_ Content: ContentManager, content: AddTopicModel) {
        
    }
    
    func didContentData(_ Content: ContentManager, content: [Sector]) {
        self.content = content
        self.filteredData = content
//        print(self.filteredData)
//        figuresByLetter = Dictionary(grouping: filteredData, by: { String($0.NAME_SECTOR) }).sorted(by: { $0.0 < $1.0 })

    
//        if (self.filteredData.count > 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
            
            self.tableView.reloadData()
            self.searchBar(self.searchBar, textDidChange: self.valueSearch)
            self.tableView.separatorStyle = .singleLine
            self.removeLoadingScreen()
            self.numberOfRows.forEach { numberOfRows in
                self.tableView.selectRow(at: numberOfRows, animated: false, scrollPosition: .middle)
            }
            
        }
//        }
    }
}


extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}



//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b, a: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
             scanner.scanLocation = 1
            //scanner.currentIndex =  scanner.string.index(ofAccessibilityElement: 1)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}




class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
