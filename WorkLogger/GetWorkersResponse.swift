
//
//  GetImgursResponse.swift
//  Imgur2
//
//  Created by Kyle Lee on 6/12/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import Foundation
import AWSS3
import AWSCognito
import AWSCore


struct GetWorkersResponse {
    let workers: [RaWorker]
    let myJson: [JSON]
    var timeDict = [Int:[String:Any]]()
    var rpofileDict = [String:Any]()
    var availability = [String:[String]]()
    
    func formatTime (string: String) -> String{
        var formatedString: String = ""
        var amPm: String = "AM"
        var myHourChecker: Int
        var hour: String = ""
        var mins: String = ""
        if string != "" {
            var token = string.components(separatedBy: "T")
            var stoken1 = token[1].components(separatedBy: ":")
            hour = stoken1[0]
            mins = stoken1[1]
            myHourChecker = (hour as NSString).integerValue
            if myHourChecker >= 12{
                myHourChecker = myHourChecker - 12
                if myHourChecker == 0 {
                    myHourChecker = 12
                }
                amPm = "PM"
            }
            formatedString = "\(myHourChecker):\(stoken1[1])\(amPm)"
        }
        return formatedString
    }
    
    init(json: JSON) throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorker(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        var start: String = ""
        var end: String = ""
        var timeArr = [String]()
        var counter: Int = 0
        for ras in rjson {
            start = self.formatTime(string: "\(ras["start"] ?? "0")")
            end = self.formatTime(string: "\(ras["end"] ?? "0")")
//            print(start,end)
            timeDict[counter] = ["\(ras["user_id"] ?? "0")": "\(start) - \(end)"]
//            print("ProfileDict at counter \(counter) is ", timeDict[counter] ?? "nil" )
            counter += 1
            timeArr.append(start)
            timeArr.append(end)
            availability["\(ras["user_id"] ?? "0")"] = timeArr
            timeArr.removeAll()
        }
//        for x in 0...timeDict.count-1{
//            for (myKey,value) in (timeDict[x])! {
//                print(" \t this is my value  \(myKey)  and this is my value", value)
//            }
//        }
//        print("this is worker profiles in getworkerResponse\n", profiles)
//        print("")
    }
}


struct GetWorkersAvailability {
    let workers: [RaWorkerLogs]
    let myJson: [JSON]
    var messageDict = [Int:[String:Any]]()
    var messageAndProfil = [String:[String]]()
    var raWorker2 = RaWorkerLogs2()
    var raWorker2Array = [RaWorkerLogs2()]
    var workerProfiles = [RaWorkerProfiles]()
   var infoString: String = ""
    
    func formatTime2 (string: String) -> (String,String){
        var start: String = ""
        var end: String = ""
        if string != "" {
            var token = string.components(separatedBy: "-")
            start = token[0]
            end = token[1]
        }
        return (start,end)
    }
    
    func formatTime (string: String) -> String{
        var formatedString: String = ""
        var amPm: String = "AM"
        var myHourChecker: Int
        var hour: String = ""
        var mins: String = ""
        if string != "" {
            var token = string.components(separatedBy: "T")
            var stoken1 = token[1].components(separatedBy: ":")
            hour = stoken1[0]
            mins = stoken1[1]
            myHourChecker = (hour as NSString).integerValue
            if myHourChecker >= 12{
                myHourChecker = myHourChecker - 12
                if myHourChecker == 0 {
                    myHourChecker = 12
                }
                amPm = "PM"
            }
            formatedString = "\(myHourChecker):\(stoken1[1])\(amPm)"
        }
        return formatedString
    }
    
    func formatIntoSecs(string: String) -> String {
        var timeInSecs: String = ""
        var myInt2: Int
        if string != "" {
            myInt2 = (string as NSString).integerValue
            myInt2 = myInt2 / 60
            timeInSecs = "\(myInt2)"
        }
        return timeInSecs
    }
    
    
    init (json: JSON,  profiledict: [Int:[String:Any]])throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorkerLogs(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        var raDataString: String = ""
        var startAt: String = ""
        var startAtFormated: String = ""
        var endAt: String = ""
        var endAtFormated: String = ""
        var raId: String = ""
        var counter: Int = 0
        var messageAndProfil = [String:[String]]()
        var messagesArray = [String]()
        var currKeysArray = ["",""]
        var lcounter = 1
        //                print("this is messages in getmessages\n", self.workers)
        raWorker2Array.removeAll()
        for ras in rjson {
            /* start = self.formatTime(string: "\(ras["start"] ?? "0")")
             end = self.formatTime(string: "\(ras["end"] ?? "0")")
             print(start,end)
             timeDict[counter] = ["\(ras["user_id"] ?? "0")": "\(start) - \(end)"] */
            startAt = "\(ras["start"] ?? "nil")"
            endAt = " \(ras["end"] ?? "nil")"
            startAtFormated = formatTime(string: startAt)
            endAtFormated = formatTime(string: endAt)
            raDataString = "\(startAtFormated) \(ras["data"] ?? "nil") \(ras["audio_file_tag"] ?? "nil"). \(endAtFormated) mins since last update"
            raId = "\(ras["user_id"] ?? "nil")"
            messageDict[counter] = ["\(raId )":raDataString ]
            // func (timeX:Int, profY:Int, timeDict:[Int:[String:Any]], profDict:[Int:[String:Any]], idChek:String)
            for x in 0...profiledict.count - 1 {
               
                    for (keys,value) in (profiledict[x])! {
                       
                            
                        if "\(keys)" == "\(raId)" {
                                
                                  raWorker2.name = "\(value)"
                                   raWorker2.startTime = startAtFormated
                                    raWorker2.endTime = endAtFormated
                                    raWorker2Array.append(raWorker2)
                            }
//                        break
                    }
                    //                    break
                
            }
        }
        if raWorker2Array.count > 0 {
        for x in 0...raWorker2Array.count - 1 {
            infoString += "\n"
            infoString += raWorker2Array[x].name
            infoString += "  "
            infoString += raWorker2Array[x].startTime+" - "+raWorker2Array[x].endTime
        }
      }
    }
}


struct GetWorkersWeekAvailability {
    let workers: [RaWorkerLogs]
    let myJson: [JSON]
    var messageDict = [Int:[String:Any]]()
    var messageAndProfil = [String:[String]]()
    var raWorker2 = RaWorkerLogs2()
    var raWorker2Array = [RaWorkerLogs2()]
    var workerProfiles = [RaWorkerProfiles]()
     var infoString: String = ""
    func formatTime2 (string: String) -> (String,String){
        var start: String = ""
        var end: String = ""
        if string != "" {
            var token = string.components(separatedBy: "-")
            start = token[0]
            end = token[1]
        }
        return (start,end)
    }
    
    func formatTime (string: String) -> String{
        var formatedString: String = ""
        var amPm: String = "AM"
        var myHourChecker: Int
        var hour: String = ""
        var mins: String = ""
        if string != "" {
            var token = string.components(separatedBy: "T")
            var stoken1 = token[1].components(separatedBy: ":")
            hour = stoken1[0]
            mins = stoken1[1]
            myHourChecker = (hour as NSString).integerValue
            if myHourChecker >= 12{
                myHourChecker = myHourChecker - 12
                if myHourChecker == 0 {
                    myHourChecker = 12
                }
                amPm = "PM"
            }
            formatedString = "\(myHourChecker):\(stoken1[1])\(amPm)"
        }
        return formatedString
    }
    
    func formatIntoSecs(string: String) -> String {
        var timeInSecs: String = ""
        var myInt2: Int
        if string != "" {
            myInt2 = (string as NSString).integerValue
            myInt2 = myInt2 / 60
            timeInSecs = "\(myInt2)"
        }
        return timeInSecs
    }
    
    
    init (json: JSON,  profiledict: [Int:[String:Any]])throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorkerLogs(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        var raDataString: String = ""
        var startAt: String = ""
        var startAtFormated: String = ""
        var endAt: String = ""
        var endAtFormated: String = ""
        var raId: String = ""
        var dayworker = RaWorkerLogs2()
        var sundayArray = [RaWorkerLogs2()]
        var mondayArray = [RaWorkerLogs2()]
        var tuesdayArray = [RaWorkerLogs2()]
        var wednesdayArray = [RaWorkerLogs2()]
        var thursdayArray = [RaWorkerLogs2()]
        var fridayArray = [RaWorkerLogs2()]
        var saturdayArray = [RaWorkerLogs2()]
        var counter: Int = 0
        var messageAndProfil = [String:[String]]()
        var messagesArray = [String]()
        var dayArray = ["Sunday"]
        var lcounter = 1
        var day: String = ""
        //                print("this is messages in getmessages\n", self.workers)
        raWorker2Array.removeAll()
        for ras in rjson {
            startAt = "\(ras["start"] ?? "nil")"
            endAt = " \(ras["end"] ?? "nil")"
            startAtFormated = formatTime(string: startAt)
            endAtFormated = formatTime(string: endAt)
            day = ras["day"] as! String
            raDataString = "\(startAtFormated) \(ras["day"] ?? "nil") "
            raId = "\(ras["user_id"] ?? "nil")"
            messageDict[counter] = ["\(raId )":raDataString ]
            for x in 0...profiledict.count - 1 {
                
                for (keys,value) in (profiledict[x])! {
                    
                    
                    if "\(keys)" == "\(raId)" {
                        
                        raWorker2.name = "\(value)"
                        raWorker2.day = day
                        raWorker2.startTime = startAtFormated
                        raWorker2.endTime = endAtFormated
                        raWorker2Array.append(raWorker2)
                        if day == "Sunday" {
                            sundayArray.append(raWorker2)
                        } else if day == "Monday" {
                            mondayArray.append(raWorker2)
                        } else if day == "Tuesday" {
                            tuesdayArray.append(raWorker2)
                        }
                        else if day == "Wednesday" {
                            wednesdayArray.append(raWorker2)
                        }else if day == "Thursday" {
                            thursdayArray.append(raWorker2)
                        }else if day == "Friday" {
                            fridayArray.append(raWorker2)
                        }else if day == "Saturday" {
                            saturdayArray.append(raWorker2)
                        }
                    }
                    //                        break
                }
                //                    break
                
            }
            
            
            
        }
        
        infoString += "--- SUNDAY ---"
        if sundayArray.count > 1 {
        for x in 1...sundayArray.count - 1 {
            infoString += "\n"
           infoString += sundayArray[x].name
             infoString += "  "
            infoString += sundayArray[x].startTime + " - " + sundayArray[x].endTime
        }
        }
        infoString += "\n\n--- MONDAY ---"
        if mondayArray.count > 1 {
        for x in 1...mondayArray.count - 1 {
            infoString += "\n"
            infoString += mondayArray[x].name
            infoString += "  "
            infoString += mondayArray[x].startTime + " - " + mondayArray[x].endTime
        }
        }
        infoString += "\n\n--- TUESDAY ---"
        if tuesdayArray.count > 1 {
        for x in 1...tuesdayArray.count - 1 {
            infoString += "\n"
            infoString += tuesdayArray[x].name
            infoString += "  "
            infoString += tuesdayArray[x].startTime + " - " + tuesdayArray[x].endTime
        }
        }
        infoString += "\n\n--- WEDNESDAY ---"
        if wednesdayArray.count > 1 {
        for x in 1...wednesdayArray.count - 1 {
            infoString += "\n"
            infoString += wednesdayArray[x].name
            infoString += "  "
            infoString += wednesdayArray[x].startTime + " - " + wednesdayArray[x].endTime
        }
        }
        infoString += "\n\n--- THURSDAY ---"
        if thursdayArray.count > 1 {
        for x in 1...thursdayArray.count - 1 {
            infoString += "\n"
            infoString += thursdayArray[x].name
            infoString += "  "
            infoString += thursdayArray[x].startTime + " - " + thursdayArray[x].endTime
        }
        }
        infoString += "\n\n--- FRIDAY ---"
        if fridayArray.count > 1 {
        for x in 1...fridayArray.count - 1 {
            infoString += "\n"
            infoString += fridayArray[x].name
            infoString += "  "
            infoString += fridayArray[x].startTime + " - " + fridayArray[x].endTime
        }
        }
        infoString += "\n\n--- SATURDAY ---"
        if saturdayArray.count > 1 {
        for x in 1...saturdayArray.count - 1 {
            infoString += "\n"
            infoString += saturdayArray[x].name
            infoString += "  "
            infoString += saturdayArray[x].startTime + " - " + saturdayArray[x].endTime
        }
        }
    }
}



struct GetWorkersMessages {
    let workers: [RaWorkerLogs]
    let myJson: [JSON]
    var messageDict = [Int:[String:Any]]()
    var messageAndProfil = [String:[String]]()
    var raWorker2 = RaWorkerLogs2()
    var raWorker2Array = [RaWorkerLogs2()]
    var workerProfiles = [RaWorkerProfiles]()
    var messageTodayString: String = ""
    var messageActiveString: String = ""
    var messageUpcomingString: String = ""
    var messagePreviousString: String = ""
    
    func formatTime2 (string: String) -> (String,String){
        var start: String = ""
        var end: String = ""
        if string != "" {
            var token = string.components(separatedBy: "-")
            if token.count > 1 {
            start = token[0]
            end = token[1]
            }
        }
        return (start,end)
    }
    func compareTime(endTime:String) -> Bool {
        let timeNow = getTimeStamp()
        var thour: String = ""
        var tmin: String = ""
        var myHour: String = ""
        var myMin: String = ""
        var myHourInt: Int = 0
        var myMinInt: Int = 0
        var tHourInt: Int = 0
        var tMinInt: Int = 0
        let token = endTime.components(separatedBy: ":")
        myHour = token[0]
        myMin = token[1]
        if myMin.contains("P") {
            let endIndex = myMin.index(myMin.endIndex, offsetBy: -2)
            let truncated = myMin.substring(to: endIndex)
            myHourInt = Int(myHour) ?? 0
            myMinInt = Int(truncated) ?? 0
            myHourInt += 12
            
        } else {
            let endIndex = myMin.index(myMin.endIndex, offsetBy: -2)
            let truncated = myMin.substring(to: endIndex)
            myHourInt = Int(myHour) ?? 0
            myMinInt = Int(truncated) ?? 0
            
        }
        var token2: [String] = timeNow.components(separatedBy: ":")
        thour = token2[0]
        tmin = token2[1]
        if tmin.contains("P") {
            let endIndex = tmin.index(tmin.endIndex, offsetBy: -2)
            let truncated = tmin.substring(to: endIndex)
            tHourInt = Int(thour) ?? 0
            tMinInt = Int(truncated) ?? 0
            tHourInt += 12
           
        } else {
            let endIndex = myMin.index(myMin.endIndex, offsetBy: -2)
            let truncated = myMin.substring(to: endIndex)
            tHourInt = Int(thour) ?? 0
            tMinInt = Int(truncated) ?? 0
            
        }
        
        if tHourInt < myHourInt {
            return true
        } else if tHourInt == myHourInt {
            if tMinInt < myMinInt {
               return true
            }
            else if tMinInt == myMinInt {
                return false
            }
        }
        
       return false
    }
    
    func getTimeStamp() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        var hour = components.hour
        let minute = components.minute
        var amPm: String = "AM"
        
        
        if hour! >= 12{
            hour = hour! - 12
            if hour! == 0 {
                hour! = 12
            }
            amPm = "PM"
        }
        
        return "\(hour ?? 0):\(minute ?? 0)\(amPm)"
    }
    func formatTime (string: String) -> String{
        var formatedString: String = ""
        var amPm: String = "AM"
        var myHourChecker: Int
        var hour: String = ""
        var mins: String = ""
        if string != "" {
            var token = string.components(separatedBy: "T")
            var stoken1 = token[1].components(separatedBy: ":")
            hour = stoken1[0]
            mins = stoken1[1]
            myHourChecker = (hour as NSString).integerValue
            if myHourChecker >= 12{
                myHourChecker = myHourChecker - 12
                if myHourChecker == 0 {
                    myHourChecker = 12
                }
                amPm = "PM"
            }
            formatedString = "\(myHourChecker):\(stoken1[1])\(amPm): "
        }
        return formatedString
    }
    
    func formatIntoSecs(string: String) -> String {
        var timeInSecs: String = ""
        var myInt2: Int
        if string != "" {
            myInt2 = (string as NSString).integerValue
            myInt2 = myInt2 / 60
            timeInSecs = "\(myInt2)"
        }
        return timeInSecs
    }
    
    var workersAvail = [String:[String]]()
    var currentWorkersDict = [String:String] ()
    var names = [String:String]()
    init (json: JSON, hoursToday: [String:String], hoursWeek: [String:String])throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorkerLogs(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        if let workersAvail:[String:[String]] = UserDefaults.standard.object(forKey: "availArray") as? [String:[String]] {
            self.workersAvail = workersAvail
        }
        if let currentWorkersDict:[String:String] = UserDefaults.standard.object(forKey: "currWorkersDict") as? [String:String] {
            self.currentWorkersDict = currentWorkersDict
        }
        if let names:[String:String] = UserDefaults.standard.object(forKey: "nameDict") as? [String:String] {
            self.names = names
        }

        var raDataString: String = ""
        var createdAt: String = ""
        var createdAtFormated: String = ""
        var timeSinceLastMess: String = ""
        var timeSinceLastMessFormated: String = ""
        var raId: String = ""
        var counter: Int = 0
        var messageAndProfil = [String:[String]]()
        var messagesArray = [String]()
        var currKeysArray = ["",""]
        var lcounter = 1
//                print("this is messages in getmessages\n", self.workers)
        
        for ras in rjson {
            createdAt = "\(ras["created_at"] ?? "nil")"
            timeSinceLastMess = " \(ras["time_since_last_message"] ?? "nil")"
            createdAtFormated = formatTime(string: createdAt)
            timeSinceLastMessFormated = formatIntoSecs(string: timeSinceLastMess)
            raDataString = "\(createdAtFormated) \(ras["data"] ?? "nil") \(ras["audio_file_tag"] ?? "nil"). \(timeSinceLastMessFormated) mins since last update"
            raId = "\(ras["user_id"] ?? "nil")"
            messageDict[counter] = ["\(raId )":raDataString ]
            // func (timeX:Int, profY:Int, timeDict:[Int:[String:Any]], profDict:[Int:[String:Any]], idChek:String)
            for (nkey,nval) in names  {
                
                            
                            if "\(nkey)" == "\(raId)" {
                                lcounter += 1
                                currKeysArray.append("\(raId)")
                                if currKeysArray.count > 0 {
                                    if currKeysArray[lcounter] != currKeysArray[lcounter-1]{
                                        messagesArray.removeAll()
                                        messagesArray.append("\(nkey)")
                                    }
                                    if messagesArray.count > 0 {
                                        if "\(messagesArray[messagesArray.count - 1])" != "\(raDataString)" {
                                            messagesArray.append("\(raDataString)")
                                            messageAndProfil["\(nval)"] = messagesArray
                                        }
                                    }
                                    
                                }
                                
                                break
                            }
                
               
            }
            counter += 1
            
            
        }
        
        
        var strng = ""
        var userId = ""
        var time: (String,String)
        
        // set message and profile here
        //UserDefaults.standard.set(messageAndProfil, forKey: "messagesDict")
        if messageAndProfil.isEmpty {
          for (x,y) in workersAvail {
                for (a,b) in names{
                    if x == a {
                        raWorker2.name = b
                        raWorker2.startTime = y[0]
                        raWorker2.endTime = y[1]
                        break 
                    }
                }
            for (tkeys,tval) in hoursToday {
                if tkeys == x {
                    raWorker2.hoursToday = tval
                    break
                }
            }
            
            for (wkeys,wval) in hoursWeek {
                if wkeys == x {
                    raWorker2.hoursThisWeek = wval
                    break
                }
            }
            raWorker2Array.append(raWorker2)
           }
        } else {
        for (keys,values) in messageAndProfil {
            raWorker2.name = keys
            
            for (tkeys,tval) in hoursToday {
                if tkeys == keys {
                    raWorker2.hoursToday = tval
                    break
                }
            }
            for (wkeys,wval) in hoursWeek {
                if wkeys == keys {
                    raWorker2.hoursThisWeek = wval
                    break
                }
            }
            
            for x in 1...values.count - 1 {
                userId = "\(values[0])"
                strng += "\(values[x])"
                strng += " \n    "
            }
            time = formatTime2(string: userId)
            raWorker2.user_id = userId
            raWorker2.dataString = strng
            for (akey,aval) in workersAvail {
                if raWorker2.user_id == akey {
                    raWorker2.startTime = aval[0]
                    raWorker2.endTime = aval[1]
                }
            }
            raWorker2Array.append(raWorker2)
            
            strng = ""   // you dont know how much of a huge bug this cost me ...
          } // do something if this is empy
        }
        if raWorker2Array.count > 1 {
            
            messageTodayString += "--- Previous Sessions ----\n"
            for x in 1...raWorker2Array.count - 1 {
                if  !compareTime(endTime: raWorker2Array[x].endTime ?? "00") {
                    messagePreviousString += raWorker2Array[x].name ?? " "
                    messageTodayString += raWorker2Array[x].name  ?? " "
                    messageTodayString += " "
                    messagePreviousString += " "
                    messageTodayString += "\(raWorker2Array[x].startTime ?? " ") - \(raWorker2Array[x].endTime ?? " ")"
                    messagePreviousString += "\(raWorker2Array[x].endTime ?? " ") - \(raWorker2Array[x].startTime ?? " ")"
                    messageTodayString += " hours\n"
                    messagePreviousString += " hours\n"
                    messagePreviousString += raWorker2Array[x].hoursToday
                    messagePreviousString += " hours today\n"
                    messagePreviousString += raWorker2Array[x].hoursThisWeek
                    messagePreviousString += " hours this week\n"
                    messagePreviousString += raWorker2Array[x].dataString
                    messagePreviousString += " \n\n"
                }
                
            }
            
             messageTodayString += "\n--- Active Sessions ----\n"
            if currentWorkersDict.count > 0 {
                messageActiveString = "--- Active Sessions ----"
                for (ckeys,cval) in currentWorkersDict {
                    for x in 1...raWorker2Array.count - 1 {
                        if ckeys == raWorker2Array[x].user_id {
                            messageActiveString += "\n\n\n"
                            messageActiveString += raWorker2Array[x].name
                            messageTodayString += raWorker2Array[x].name
                            messageTodayString += raWorker2Array[x].hoursToday
                            messageTodayString += " hours"
                            messageActiveString += "\nhours worked this week"
                            messageActiveString += raWorker2Array[x].hoursThisWeek
                            messageActiveString += "\nhours worked today"
                            messageActiveString += raWorker2Array[x].hoursToday
                            messageActiveString += "\n\n"
                            messageActiveString += raWorker2Array[x].dataString
                            
                        }
                    }
                }
            }
            messageTodayString += "\n--- UpComing Sessions ----\n\n"
        for x in 1...raWorker2Array.count - 1 {
            if  compareTime(endTime: raWorker2Array[x].startTime ?? "00") {
                messageUpcomingString += raWorker2Array[x].name ?? " "
                messageTodayString += raWorker2Array[x].name  ?? " "
                messageTodayString += " "
                messageUpcomingString += " "
                messageTodayString += "\(raWorker2Array[x].startTime ?? " ") - \(raWorker2Array[x].endTime ?? " ")"
                messageUpcomingString += "\(raWorker2Array[x].startTime ?? " ") - \(raWorker2Array[x].endTime ?? " ")"
                messageTodayString += " hours\n"
                messageUpcomingString += " hours\n"
            }

            }
            messageTodayString += "\n\n"
    if messageAndProfil.isEmpty == false {
        for x in 1...raWorker2Array.count - 1 {
            messageTodayString += "\n\n\n"
            messageTodayString += raWorker2Array[x].name ?? " "
            messageTodayString += "\nhours worked this week"
            messageTodayString += raWorker2Array[x].hoursThisWeek ?? " "
            messageTodayString += "\nhours worked today"
            messageTodayString += raWorker2Array[x].hoursToday ?? " "
            messageTodayString += "\n\n"
            messageTodayString += raWorker2Array[x].dataString ?? " "
        }
       }   
            
    }
  }
}


struct GetWorkersMessagesAudio {
    let workers: [RaWorkerLogs]
    let myJson: [JSON]
    var messageDict = [Int:[String:Any]]()
    var messageAndProfil = [String:[String]]()
    var raWorker2 = RaWorkerLogs2()
    var raWorker2Array = [RaWorkerLogs2()]
    var workerProfiles = [RaWorkerProfiles]()
    var infoString: String = ""
    var workersAvail = [String:[String]]()
    var currentWorkersDict = [String:String] ()
    var names = [String:String]()
    
    func formatTime2 (string: String) -> (String,String){
        var start: String = ""
        var end: String = ""
        if string != "" {
            var token = string.components(separatedBy: "-")
            start = token[0]
            end = token[1]
        }
        return (start,end)
    }
    
    func formatTime (string: String) -> String{
        var formatedString: String = ""
        var amPm: String = "AM"
        var myHourChecker: Int
        var hour: String = ""
        var mins: String = ""
        if string != "" {
            var token = string.components(separatedBy: "T")
            var stoken1 = token[1].components(separatedBy: ":")
            hour = stoken1[0]
            mins = stoken1[1]
            myHourChecker = (hour as NSString).integerValue
            if myHourChecker >= 12{
                myHourChecker = myHourChecker - 12
                if myHourChecker == 0 {
                    myHourChecker = 12
                }
                amPm = "PM"
            }
            formatedString = "\(myHourChecker):\(stoken1[1])\(amPm): "
        }
        return formatedString
    }
    
    func formatIntoSecs(string: String) -> String {
        var timeInSecs: String = ""
        var myInt2: Int
        if string != "" {
            myInt2 = (string as NSString).integerValue
            myInt2 = myInt2 / 60
            timeInSecs = "\(myInt2)"
        }
        return timeInSecs
    }
    
    
    init (json: JSON,  profiledict: [Int:[String:Any]], timedict: [Int:[String:Any]])throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorkerLogs(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        if let workersAvail:[String:[String]] = UserDefaults.standard.object(forKey: "availArray") as? [String:[String]] {
            self.workersAvail = workersAvail
        }
        if let currentWorkersDict:[String:String] = UserDefaults.standard.object(forKey: "currWorkersDict") as? [String:String] {
            self.currentWorkersDict = currentWorkersDict
        }
        if let names:[String:String] = UserDefaults.standard.object(forKey: "nameDict") as? [String:String] {
            self.names = names
        }
        var raDataString: String = ""
        var createdAt: String = ""
        var createdAtFormated: String = ""
        var timeSinceLastMess: String = ""
        var timeSinceLastMessFormated: String = ""
        var raId: String = ""
        var counter: Int = 0
        var messageAndProfil = [String:[String]]()
        var messagesArray = [String]()
        var currKeysArray = ["",""]
        var lcounter = 1
        //                print("this is messages in getmessages\n", self.workers)
        
        for ras in rjson {
            createdAt = "\(ras["created_at"] ?? "nil")"
            timeSinceLastMess = " \(ras["time_since_last_message"] ?? "nil")"
            createdAtFormated = formatTime(string: createdAt)
//            timeSinceLastMessFormated = formatIntoSecs(string: timeSinceLastMess)
            raDataString = "\(createdAtFormated) \(ras["data"] ?? "nil") \(ras["audio_file_tag"] ?? "nil"). \(timeSinceLastMess) mins since last update"
            raId = "\(ras["user_id"] ?? "nil")"
            messageDict[counter] = ["\(raId )":raDataString ]
            for (nkey,nval) in names  {
                
                
                if "\(nkey)" == "\(raId)" {
                    lcounter += 1
                    currKeysArray.append("\(raId)")
                    if currKeysArray.count > 0 {
                        if currKeysArray[lcounter] != currKeysArray[lcounter-1]{
                            messagesArray.removeAll()
                            messagesArray.append("\(nkey)")
                        }
                        if messagesArray.count > 0 {
                            if "\(messagesArray[messagesArray.count - 1])" != "\(raDataString)" {
                                messagesArray.append("\(raDataString)")
                                messageAndProfil["\(nval)"] = messagesArray
                            }
                        }
                        
                    }
                    
                    break
                }
                
                
            }
            counter += 1
            
            
        }
        var strng = ""
        var timeHolder = ""
        var time: (String,String)
        for (keys,values) in messageAndProfil {
            raWorker2.name = keys
            
            for x in 1...values.count - 1 {
//                timeHolder = "\(values[0])"
                strng += "  \(values[x])"
                strng += " \n    "
            }
//            time = formatTime2(string: timeHolder)
//            raWorker2.hoursWorkedToday = timeHolder
//            raWorker2.startTime = time.0
//            raWorker2.endTime = time.1
            raWorker2.dataString = strng
            raWorker2Array.append(raWorker2)
            strng = ""   // you dont know how much of a huge bug this cost me ...
        }
        
        for x in 1...raWorker2Array.count - 1 {
            infoString += "\n\n\n"
            infoString += raWorker2Array[x].name
            infoString += "\n\n"
//            infoString += raWorker2Array[x].hoursWorkedToday
//            infoString += "\n"
//            infoString += (raWorker2Array[x].startTime + raWorker2Array[x].endTime)
//            infoString += "\n\n"
            infoString += raWorker2Array[x].dataString
        }
    }
}


struct GetWorkersProfile {
    let workers: [RaWorkerProfiles]
    let myJson: [JSON]
    var profileDict = [Int:[String:Any]]()
    var rpofileDict = [String:String]()
    
    init(json: JSON) throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorkerProfiles(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        var counter: Int = 0
//        print("this is messages in getmessages\n", self.workers)
//        print("")
        for ras in rjson {
            profileDict[counter] = ["\(ras["id"] ?? "nil")":ras["name"] ?? "nil"]
            //            print("ProfileDict at counter \(counter) is ", profileDict[counter] ?? "nil" )
            counter += 1
        }
        for ras in rjson {
            rpofileDict["\(ras["id"] ?? "nil")"] = ras["name"] as! String
            //            counter += 1
        }
//        for x in 0...profileDict.count - 1{
//            for myKey in (profileDict[x]?.keys)! {
//                //            print(" \t this is my value  \(myKey)")
//            }
        }
        
    }

struct GetCurrWorkersProfile {
    let workers: [RaWorkerProfiles]
    let myJson: [JSON]
    var profileDict = [Int:[String:Any]]()
    var rpofileDict = [String:String]()
    
    init(json: JSON) throws {
        guard let responsse = json["response"] as? String else { print("not a String in GetworkersResponse"); throw MyError.someError }
        let text = responsse
        let rdata = text.data(using: .utf8)
        guard let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String: Any]] else { throw MyError.someError }
        let worker = rjson.map{ RaWorkerProfiles(json: $0)}.flatMap {$0}
        self.myJson = rjson
        self.workers = worker
        var counter: Int = 0
        //        print("this is messages in getmessages\n", self.workers)
        //        print("")
        for ras in rjson {
            profileDict[counter] = ["\(ras["id"] ?? "nil")":ras["name"] ?? "nil"]
            //            print("ProfileDict at counter \(counter) is ", profileDict[counter] ?? "nil" )
            counter += 1
        }
        for ras in rjson {
            rpofileDict["\(ras["user_id"] ?? "nil")"] = ras["location"] as! String
            //            counter += 1
        }
        //        for x in 0...profileDict.count - 1{
        //            for myKey in (profileDict[x]?.keys)! {
        //                //            print(" \t this is my value  \(myKey)")
        //            }
    }
    
}

