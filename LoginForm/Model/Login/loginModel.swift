//
//  loginModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 29.10.2020.
//

import Foundation

struct LoginModel {
    let login: String
    let firstName: String
    let group: Int
    let status: Int
}

struct LoginData: Codable {
    let login: String
    let firstName: String
    let group: Int
    let status: Int
}
