//
//  contentModel.swift
//  LoginForm
//
//  Created by Вадим Куйда on 19.11.2020.
//

import Foundation

//MARK: MODEL




struct ContentModelStep {
    let top: [ContentModelTopStep]
}

struct ContentModelTopStep  {
    let STEP_NAME: String
}


struct AddTopicModelStep {
    let statusAddTopic: Int
}
struct AddTopicDataStep: Codable {
    let statusAddTopic: Int
}

//MARK: DATA
struct ContentDataStep: Codable  {
    let step:[TopicStep]
}

struct TopicStep: Codable {
    let id: Int
    let TOPIC_ID: Int
    let STEP_NAME: String
//    let step_topic: [Step_topic]
}





