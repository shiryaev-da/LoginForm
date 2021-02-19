//
//  stepManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.01.2021.
//


import Foundation



protocol StepManagerDelegate {
    func didPostStep(_ weatherRegister: StepManager, register: StepModel)

}

struct StepManager {
    
    var delegate: StepManagerDelegate?
    
    func performRequest (loginRegLet: String, json: String){
    
    let url = URL(string: "https://shi-ku.ru:8443/ords/interval/post_step/step/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
//     print(json)
    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = "{\"name\": \"\(loginRegLet)\",data:{ \"json\": \(json)}}".data(using: .utf8)!;
//        let postString : Data = "{}".data(using: .utf8)!;

        
//        print(postString)
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
            if let register = self.parseJSON(safeData) {
                self.delegate?.didPostStep(self, register: register)
            }
        }

    }
    task.resume()
    }
    
    func parseJSON(_ responceData: Data) -> StepModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(StepData.self, from: responceData)
    //                print(decoderData.statusUser)
            let flag = decoderData.statusAddStep
            let statusReg  = StepModel(statusAddStep: flag)
            print(statusReg.statusAddStep)
            return statusReg

        } catch {
            print(error)
            return nil
        }
    }
    


    
}

