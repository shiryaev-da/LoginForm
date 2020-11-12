//
//  registerManager.swift
//  LoginForm
//
//  Created by Вадим Куйда on 27.10.2020.
//

import Foundation



protocol RegisterManagerDelegate {
    func didUpdateRegister(_ weatherRegister: RegisterManager, register: ResponceModel)

}

struct RegisterManager {
    
    var delegate: RegisterManagerDelegate?
    
    func performRequest (nameRegLet: String, loginRegLet: String, mailRegLet: String, phoneRegLet: String, passRegLet: String , groupLet: String){
    
    let url = URL(string: "http://95.165.3.188:8082/ords/interval/create_interval_login_user/employees/")
    guard let requestUrl = url else { fatalError() }

    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
     
    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString : Data = " {\"FLD_EMAIL\": \"\(mailRegLet)\", \"FIRST_NAME\": \"\(nameRegLet)\", \"USER_LOGIN\": \"\(loginRegLet)\", \"PHONE_NUMBER\": \"\(phoneRegLet)\", \"USER_PASS\": \"\(passRegLet)\", \"FLD_GROUP\": \(groupLet)}".data(using: .utf8)!;
    
        
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
                self.delegate?.didUpdateRegister(self, register: register)
            }
        }

    }
    task.resume()
    }
    
    func parseJSON(_ responceData: Data) -> ResponceModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode(ResponceData.self, from: responceData)
    //                print(decoderData.statusUser)
            let flag = decoderData.statusUser
            let statusReg  = ResponceModel(statusUser: flag)
            print(statusReg.statusUser)
            return statusReg

        } catch {
            print(error)
            return nil
        }
    }
    


    
}
