//
//  registerModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 27.10.2020.
//

import Foundation


struct ResponceData: Codable {
    let statusUser: Int
}
struct ResponceModel {
    let statusUser: Int
    
    var statusUserStr: String {
        switch statusUser {
        case 1:
            return "Пользователь уже существует"
        case 0:
            return "Пользователь зарегистрирован"
        case 2:
            return "Не все поля заполнены"
        default:
            return "-"
    }
    }
}


struct ListGroup: Codable {
    let group: [List]
}

struct List: Codable {
    let name: String
    let group_id: Int
}



