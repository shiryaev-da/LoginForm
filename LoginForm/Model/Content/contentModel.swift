//
//  contentModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 30.10.2020.
//

import Foundation

//MARK: MODEL




struct ContentModel {
    let top: [ContentModelTop]
}

struct ContentModelTop  {
    let TOPIC_NAME: String
}


struct AddTopicModel {
    let statusAddTopic: Int
}
struct AddTopicData: Codable {
    let statusAddTopic: Int
}

//MARK: DATA
struct ContentData: Codable  {
    let topic:[Topic]
}

struct Topic: Codable {
    let id: Int
    let TOPIC_NAME: String
//    let step_topic: [Step_topic]
}






