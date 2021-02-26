//
//  commentStep.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.02.2021.
//

import UIKit
import CoreData

class commentStep: UIViewController {
    
    
    var stepId: Int!
    var itemTimeArray = [Logtimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var commentText: String!
    var commentTextCore: String = ""
    let titleLabel = UITextView()
    var stepName: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let newView = UIView(frame: CGRect(x: 0, y: 500, width: self.view.frame.width, height: 400))
        newView.backgroundColor = .cyan
        newView.layer.cornerRadius = 20
//        print(stepId)
        self.view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
 
                let labelTitil = UILabel(frame: CGRect(x:0, y: 450 ,width: self.view.frame.width ,height:50))
                labelTitil.layer.cornerRadius = 20
                labelTitil.backgroundColor = UIColor.init(red: 234.0/255.0, green: 191.0/255.0, blue: 159.0/255.0, alpha: 1)
                labelTitil.text = "  Комментарий: \(String(stepName))"
                labelTitil.baselineAdjustment = .alignCenters
                labelTitil.textAlignment = NSTextAlignment.left
                labelTitil.font = .systemFont(ofSize: 15)


        
                titleLabel.frame = CGRect(x:0, y: 500 ,width: self.view.frame.width ,height:380)
        //        titleLabel.numberOfLines = 0;
        //        titleLabel.lineBreakMode = .byWordWrapping
                titleLabel.backgroundColor = UIColor.init(red: 250.0/255.0, green: 243.0/255.0, blue: 224.0/255.0, alpha: 1)
                titleLabel.insertTextPlaceholder(with: CGSize(width: 130, height: 20))
        //        titleLabel.baselineAdjustment = .alignCenters§
                titleLabel.textAlignment = NSTextAlignment.left
                titleLabel.font = .systemFont(ofSize: 15)
        
        loadItems()
        
                titleLabel.text = addComment(value: stepId)
                
        
        

        self.view.addSubview(labelTitil)
        self.view.addSubview(newView)
        self.view.addSubview(titleLabel)
//        titleLabel


        // works without the tap gesture just fine (only dragging), but I also wanted to be able to tap anywhere and dismiss it, so I added the gesture below
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
   
    }
    
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        print(stepId)
        updateComment(value: stepId, textComment: "11223")
        dismiss(animated: true, completion: nil)
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
