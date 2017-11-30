//
//  Imgur.swift
//  Imgur2
//
//  Created by Kyle Lee on 6/12/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit



struct RaWorker {
     var user_id: Any
     var start: Any
    var end: Any
    
    init?(json: JSON){
        guard let user_id = json["user_id"] ,
            let start = json["start"] ,
            let end = json["end"]
            else { return nil }
        self.user_id = user_id
        self.start = start
        self.end = end
    }
}

struct RaWorkerLogs {
    var user_id: Any
    var data: Any
    var audio_file_tag: Any
    var time_since_last_message: Any
    var created_at: Any
    
    init?(json: JSON){
        guard let user_id = json["user_id"] ,
            let data = json["data"] ,
            let audio_file_tag = json["audio_file_tag"],
            let time_since_last_message = json["time_since_last_message"],
            let created_at = json["created_at"]
            else { return nil }
        self.user_id = user_id
        self.data = data
        self.audio_file_tag = audio_file_tag
        self.time_since_last_message = time_since_last_message
        self.created_at = created_at
    }
}

struct RaWorkerLogs2 {
    var name: String!
    var dataString: String = ""
    var startTime: String!
    var endTime: String!
    var day: String!
    var hoursThisWeek: String!  = "0.0"
    var hoursToday: String! = "0.0"
    var user_id: String! = "0.0"
    
}

struct RaWorkerProfiles {
    var name: Any
    var id: Any
    
    init?(json: JSON){
        guard let name = json["name"] ,
            let id = json["id"]
            else { return nil }
        self.name = name
        self.id = id
    }
}

