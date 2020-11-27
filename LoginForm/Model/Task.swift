//
//  Task.swift
//  LoginForm
//
//  Created by Вадим Куйда on 23.11.2020.
//

import Foundation



class Task {
  let name: String
  let creationDate = Date()
  var completed = false
  
  init(name: String) {
    self.name = name
  }
}
