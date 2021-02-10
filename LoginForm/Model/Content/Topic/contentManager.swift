//
//  contentManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 30.10.2020.
//

import Foundation


protocol ContentManagerDelegate {
    func didContentData(_ Content: ContentManager, content: [Topic])
    func didAddTopic(_ Content: ContentManager, content: AddTopicModel)
    func didDelTopic(_ Content: ContentManager, content: AddTopicModel)
    func didContentStepDataCore(_ Content: ContentManager, content: [TopicStepCore])

    
    
}

struct ContentManager {
    
    var delegate: ContentManagerDelegate?
    
    //MARK: VIEW TOPIC
    func performLogin(user: String) {
    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/mod_interval_topc_user/get_topic/\(user)")
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
                self.delegate?.didContentData(self, content: login)
            }
        }
    }
    task.resume()
    }

    func parseJSONGet(_ responceData: Data) -> [Topic]?  {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(ContentData.self, from: responceData)
            let topicname = decoderData.topic
            return topicname
        } catch {

            return nil
        }
    }
    
    //MARK: ADD TOPIC
    func performAddTopic (loginLet: String, groupLet: Int, nameTopic: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/create_interval_add_topic/topic/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER_ID\": \"\(loginLet)\", \"USER_GROUP\": \(groupLet), \"TOPIC_NAME\": \"\(nameTopic)\"}".data(using: .utf8)!;

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
                self.delegate?.didAddTopic(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONAdd(_ responceData: Data) -> AddTopicModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(AddTopicData.self, from: responceData)
    //                print(decoderData.statusUser)
            let statusAdd = decoderData.statusAddTopic
            print(statusAdd)
            let statusReg  = AddTopicModel(statusAddTopic: statusAdd)
//            print(statusReg.statusUser)
            return statusReg

        } catch {
//            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
    }
    
    //MARK: DEL TOPIC
    func performDelTopic (loginLet: String, groupLet: Int, nameTopic: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/create_interval_del_topic/topic/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER_ID\": \"\(loginLet)\", \"USER_GROUP\": \(groupLet), \"TOPIC_NAME\": \"\(nameTopic)\"}".data(using: .utf8)!;
print(" { \"USER_ID\": \(loginLet), \"USER_GROUP\": \(groupLet), \"TOPIC_NAME\": \"\(nameTopic)\"}")

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
                self.delegate?.didAddTopic(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONDel(_ responceData: Data) -> AddTopicModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(AddTopicData.self, from: responceData)
    //                print(decoderData.statusUser)
            let statusAdd = decoderData.statusAddTopic
            print(statusAdd)
            let statusReg  = AddTopicModel(statusAddTopic: statusAdd)
//            print(statusReg.statusUser)
            return statusReg

        } catch {
//            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
    }
    
    
    //MARK: GET STEP
    func performStep (loginLet: String){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/post_step_coredata/user/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER\": \"\(loginLet)\"}".data(using: .utf8)!;
print(" { \"USER\": \"\(loginLet)\"}")

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
            if let login = self.parseJSONStep(safeData) {
                self.delegate?.didContentStepDataCore(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONStep(_ responceData: Data) -> [TopicStepCore]? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(StepCoredataData.self, from: responceData)
    //                print(decoderData.statusUser)
            let stepCore = decoderData.step
//            print(stepCore)
//            let statusReg  = StepCoredataModel(user: statusAdd)
//            print(statusReg.statusUser)
            return stepCore

        } catch {
//            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
    }
    


    
    
}
