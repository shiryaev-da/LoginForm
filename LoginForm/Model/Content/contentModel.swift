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


struct StepCoredataData: Codable {
    let step: [TopicStepCore]
}
struct TopicStepCore: Codable {
    let USERNAME: String
    let TOPICID: String
    let STEPID: String
    let DATETIMESTART: String
    let DATETIMEEND: String
    let FLAGACTIVE: String
    let ACTIVEID: Int
}



//MARK: DATA
struct ContentData: Codable  {
    let topic:[Topic]
}

struct Topic: Codable {
    let id: Int
    let TOPIC_NAME: String
    let COUNT_STEP: Int
    let NAME_SECTOR: String
    let FLD_COMMENT: String
//    let step_topic: [Step_topic]
}



