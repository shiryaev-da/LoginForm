//
//  commentStep.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.02.2021.
//

import UIKit
import CoreData

class commentStep: UIViewController, UITextViewDelegate {
    
    
    var stepId: Int!
    var itemTimeArray = [Logtimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var commentText: String!
    var commentTextCore: String = ""
    let titleLabel = UITextView()
    var stepName: String!
    var stepNum: Int!
    var placeholderLabel = UILabel()
    var titleLabelMain = UILabel()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.delegate = self
        let newView = UIView(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 400))
        newView.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
//        newView.layer.cornerRadius = 20
//        print(stepId)
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        
        print(self.view.frame.size)
        
        print(view.frame.size)
 
            // Заголовок
            let labelTitilAll = UIView(frame: CGRect(x:0, y: 430 ,width: self.view.frame.width ,height:80))
            labelTitilAll.layer.cornerRadius = 10
            labelTitilAll.backgroundColor = .white
            
                //Номер шага
                    let labelTitilStep = UILabel(frame: CGRect(x:16, y: 12 ,width: self.view.frame.width ,height: 10))
                    labelTitilStep.text = "Шаг \(String(stepNum))"
                    labelTitilStep.font = UIFont(name: "SBSansText-Regular", size: 12)
                    labelTitilStep.numberOfLines = 1
                    labelTitilStep.textColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1)
                    labelTitilStep.layer.cornerRadius = 20
                //Название шага
                    let labelTitil = UILabel(frame: CGRect(x:16, y: 22 ,width: self.view.frame.width-10 ,height:labelTitilAll.frame.height/2))
                    labelTitil.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
                    labelTitil.text =  (String(stepName))
                    labelTitil.baselineAdjustment = .alignCenters
                    labelTitil.textAlignment = NSTextAlignment.left
                    labelTitil.font = UIFont(name: "SBSansText-Regular", size: 17)
                    labelTitil.numberOfLines = 1

            labelTitilAll.addSubview(labelTitilStep)
            labelTitilAll.addSubview(labelTitil)

//        placeholderLabel.isHidden = !toTextView.text.isEmpty
        
            //  Основной фрейм
            titleLabelMain.frame = CGRect(x:16, y: 500 ,width: newView.frame.width-32 , height: self.view.frame.maxY - 500 - 70)
            titleLabelMain.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 0)

                titleLabel.frame = CGRect(x:24, y: 500 ,width: newView.frame.width-48 , height: titleLabelMain.frame.maxY - 500 - 70)
                titleLabel.backgroundColor = UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1)
                titleLabel.textAlignment = NSTextAlignment.left
                titleLabel.font = UIFont(name: "SBSansText-Regular", size: 14)

                
                    placeholderLabel.text = "Введите комментарий"
                    placeholderLabel.frame = CGRect(x:0, y: 0 ,width: self.view.frame.width , height: 15)
                    placeholderLabel.sizeToFit()
                    placeholderLabel.font = UIFont(name: "SBSansText-Regular", size: 14)
                    placeholderLabel.textColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1)
                    placeholderLabel.tag = 100
        loadItems()
        titleLabel.addSubview(placeholderLabel)
        self.view.addSubview(labelTitilAll)
        self.view.addSubview(newView)
        self.view.addSubview(titleLabelMain)
        self.view.addSubview(titleLabel)


        titleLabel.text = addComment(value: stepId)


        placeholderLabel.isHidden = !titleLabel.text.isEmpty




        // works without the tap gesture just fine (only dragging), but I also wanted to be able to tap anywhere and dismiss it, so I added the gesture below
        

        

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
   
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
//        print(!titleLabel.text.isEmpty)
        placeholderLabel.isHidden = true

//        placeholderLabel.text = ""
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {

//        updateComment(value: stepId, textComment: "11223")
//        titleLabel.text = ""
//        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
//            loadItems()
            updateComment(value: stepId, textComment: titleLabel.text)
            // TODO: Do your stuff here.
        }
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
    
    func addComment(value searchValue: Int) -> String
    {
        loadItems()
//        print(searchValue)
        if let i = itemTimeArray.lastIndex(where: { $0.stepID == Int16(searchValue)}) {
//                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                
            commentTextCore =  itemTimeArray[i].comment != nil ? itemTimeArray[i].comment! : ""
//                print(itemTimeArray[i].comment)
//                itemTimeArray[i].setValue(1, forKey: "flagActive")
//                self.saveItems()
        }
        
//        return
        
        return  commentTextCore
    }
    
    
    func updateComment(value searchValue: Int, textComment: String)
    {
            print(searchValue)
            print(textComment)
            if let i = itemTimeArray.lastIndex(where: { $0.stepID == Int16(searchValue)}) {
//                itemTimeArray[i].setValue(Date(), forKey: "dateTimeEnd")
                print(textComment)
                itemTimeArray[i].setValue(textComment, forKey: "comment")
//                itemTimeArray[i].setValue(1, forKey: "flagActive")
                self.saveItems()
        }
    }
    


}
