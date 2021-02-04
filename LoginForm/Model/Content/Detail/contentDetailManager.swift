//
//  contentDetailManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 04.02.2021.
//

import Foundation



protocol DetailManagerDelegate {
    func didShowDetail(_ Content: ContentDetailManager, content: [Detail])
    func didValidActiv(_ Content: ContentDetailManager, content: ValidAct)
    

}


struct ContentDetailManager {
    
    var delegate: DetailManagerDelegate?
    
    //MARK: show detail
    func performShowDetail (loginLet: String, topicID: Int){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/user_step_deteil/user/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"USER\": \"\(loginLet)\", \"TOPIC_ID\": \"\(topicID)\"}".data(using: .utf8)!;
        print(" { \"USER\": \"\(loginLet)\", \"TOPIC_ID\": \(topicID)\"}")

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
            if let login = self.parseJSONShowDetail(safeData) {
                self.delegate?.didShowDetail(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONShowDetail(_ responceData: Data) -> [Detail]?  {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(DetailData.self, from: responceData)
            let topicname = decoderData.detail
            print(topicname)
            return topicname
        } catch {

            return nil
        }
    }
    
    
    //MARK: ADD TOPIC
    func performValidAcctive (activeID: Int, flag: Int){

    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/active_check_valid/id/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"

    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " { \"ACTID\": \(activeID), \"FLAG\": \(flag)}".data(using: .utf8)!;

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
                self.delegate?.didValidActiv(self, content: login)
            }
        }

    }
    task.resume()
    }

    func parseJSONAdd(_ responceData: Data) -> ValidAct? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(AddTopicData.self, from: responceData)
    //                print(decoderData.statusUser)
            let statusAdd = decoderData.statusAddTopic
            print(statusAdd)
            let statusReg  = ValidAct(idActive: statusAdd)
//            print(statusReg.statusUser)
            return statusReg

        } catch {
//            let statusReg  = AddTopicModel(statusAddTopic: nil)
            return nil
        }
    }
    
    
    
    
    
    
}

