//
//  contentManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation


protocol ContentStepManagerDelegate {
    func didContentStepData(_ Content: ContentStepManager, content: [TopicStep])
    func didAddTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep)
    func didDelTopicStep(_ Content: ContentStepManager, content: AddTopicModelStep)
    
}

struct ContentStepManager {
    
    var delegate: ContentStepManagerDelegate?
    
    //MARK: VIEW TOPIC
    func performLogin(user: Int) {
    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/mod_interval_step_user/topicID/\(user)")
//        let url = URL(string: "http://95.165.3.188:8082/ords/interval/mod_interval_step_user/topicID/1")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    // HTTP Request Parameters which will be sent in HTTP Request Body
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
        if let safeData = data {
            if let login = self.parseJSONGet(safeData) {
                self.delegate?.didContentStepData(self, content: login)
            }
        }
    }
    task.resume()
    }

    func parseJSONGet(_ responceData: Data) -> [TopicStep]?  {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(ContentDataStep.self, from: responceData)
            let topicname = decoderData.step
//            print(topicname)
            return topicname
        } catch {

            return nil
        }
    }
    
//    //MARK: ADD TOPIC
    func performAddTopicStep (groupLet: Int, nameStep: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/create_interval_add_step/step/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"TOPIC_ID\": \(groupLet), \"STEP_NAME\":\"\(nameStep)\"}".data(using: .utf8)!;
    
    // Set HTTP Request Body
    request.httpBody = postString;
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
        if let safeData = data {
            if let login = self.parseJSONAdd(safeData) {
                self.delegate?.didAddTopicStep(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONAdd(_ responceData: Data) -> AddTopicModelStep? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(AddTopicData.self, from: responceData)
    //                print(decoderData.statusUser)
            let statusAdd = decoderData.statusAddTopic
            print(statusAdd)
            let statusReg  = AddTopicModelStep(statusAddTopic: statusAdd)
//            print(statusReg.statusUser)
            return statusReg

        } catch {
//            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
    }
//    
//    //MARK: DEL TOPIC
//    func performDelTopicStep (loginLet: String, groupLet: Int, nameTopic: String){
//
//    let url = URL(string: "http://95.165.3.188:8082/ords/interval/create_interval_del_topic/topic/")
//    guard let requestUrl = url else { fatalError() }
//
//    // Prepare URL Request Object
//    var request = URLRequest(url: requestUrl)
//    request.httpMethod = "POST"
//
//    // HTTP Request Parameters which will be sent in HTTP Request Body
//    let postString : Data = " { \"USER_ID\": \(loginLet), \"USER_GROUP\": \(groupLet), \"TOPIC_NAME\": \"\(nameTopic)\"}".data(using: .utf8)!;
//print(" { \"USER_ID\": \(loginLet), \"USER_GROUP\": \(groupLet), \"TOPIC_NAME\": \"\(nameTopic)\"}")
//
//    // Set HTTP Request Body
//    request.httpBody = postString;
//    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//
//    // Perform HTTP Request
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            // Check for Error
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//        if let safeData = data {
//            if let login = self.parseJSONAdd(safeData) {
//                self.delegate?.didAddTopicStep(self, content: login)
//            }
//        }
//
//    }
//    task.resume()
//    }
//
//    func parseJSONDel(_ responceData: Data) -> AddTopicModel? {
//        let decoder = JSONDecoder()
//        do{
//            let decoderData = try decoder.decode(AddTopicData.self, from: responceData)
//    //                print(decoderData.statusUser)
//            let statusAdd = decoderData.statusAddTopic
//            print(statusAdd)
//            let statusReg  = AddTopicModel(statusAddTopic: statusAdd)
////            print(statusReg.statusUser)
//            return statusReg
//
//        } catch {
////            let statusReg  = AddTopicModel(statusAddTopic: nil)
//            return nil
//        }
//    }
    
    
}
