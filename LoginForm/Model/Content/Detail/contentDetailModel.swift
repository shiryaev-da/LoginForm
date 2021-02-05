//
//  contentDetailModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 04.02.2021.
//

import Foundation



struct DetailData: Codable  {
    let detail:[Detail]
}

struct Detail: Codable {
    let ID_ART: Int
    let DATE: String
    let FLAG: Int
    let STEPFACT: Int
    let STEPPLAN: Int
    let TIMEALL: Int
}


struct ValidAct: Codable  {
    let idActive: Int
}
