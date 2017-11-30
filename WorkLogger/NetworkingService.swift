//
//  NetworkingService.swift
//  Imgur2
//
//  Created by Kyle Lee on 6/12/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit
import AWSS3

typealias JSON = [String: Any]



class MyNetworkingService {
    static let shared = MyNetworkingService()
    private init() {}
    let session = URLSession.shared
    var workerProfiles = [RaWorkerProfiles]()
    
    // get current users
    func getCurrentWorkers(id: String, success successBlock: @escaping (GetCurrWorkersProfile) -> Void){
        let parameters = ["manager_id": id] //availabilities/current_users"
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/worker_sessions/current_users") // for post requests use post current_users
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            
//            print("\n\nThis is the response: ",response)
            guard let mdata = mdata  else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
//                print("this is json for get cur users", json)
                let getworkersResponse = try GetCurrWorkersProfile(json: json)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
        }.resume()
    }
    
    func availabilityToday(id: String, success successBlock: @escaping (GetWorkersResponse) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/today") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
//                print("this is json for get cur users", json)
                let getworkersResponse = try GetWorkersResponse(json: json)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    
    func availabilityTodayToday(profileDict: [Int:[String:Any]], id: String, success successBlock: @escaping (GetWorkersAvailability) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/today") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
                //                print("this is json for get cur users", json)
                let getworkersResponse = try GetWorkersAvailability(json: json, profiledict: profileDict)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    
    func availabilityTomorrowTomorrow(profileDict: [Int:[String:Any]], id: String, success successBlock: @escaping (GetWorkersAvailability) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/tomorrow") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
               
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
                //                print("this is json for get cur users", json)
                let getworkersResponse = try GetWorkersAvailability(json: json, profiledict: profileDict)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    
    func availabilityTomorrow(id: String, success successBlock: @escaping (GetWorkersResponse) -> Void){
        let parameters = ["manager_id": id ]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/tomorrow") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                self.getWorkersProfile(id: id, success: { (profileResponse) in
                    self.workerProfiles = profileResponse.workers
                })
//                print("Workers profile info ",self.workerProfiles)
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
//                print("this is json for get cur users", json)
                let getworkersResponse = try GetWorkersResponse(json: json)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    
    func availabilityWeekWeek(profileDict: [Int:[String:Any]], id: String, success successBlock: @escaping (GetWorkersWeekAvailability) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/weekly") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
                //                print("this is json for get cur users", json)
                let getworkersResponse = try GetWorkersWeekAvailability(json: json, profiledict: profileDict)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    
    func availabilityWeek(id: String, success successBlock: @escaping (GetWorkersResponse) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/weekly") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                self.getWorkersProfile(id: id, success: { (profileResponse) in
                    self.workerProfiles = profileResponse.workers
                })
//                print("Workers profile info ",self.workerProfiles)
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
//                print("this is json for get cur users", json)
                let getworkersResponse = try GetWorkersResponse(json: json)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    
    func getMessagesToday( hoursWorkedWeekDict: [String: String], hoursWorkedTodayDict: [String: String], id: String, success successBlock: @escaping (GetWorkersMessages) -> Void){

        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/messages/today") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {

                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}

                let getworkersMessages = try GetWorkersMessages(json: json, hoursToday: hoursWorkedTodayDict, hoursWeek: hoursWorkedWeekDict)
                DispatchQueue.main.async {
                    successBlock(getworkersMessages)
                }
            } catch {}
            }.resume()
    }
    
    
    func getMessagesTodayAudio(timeDicts: [Int: [String:Any]], profileDicts: [Int: [String:Any]], id: String, success successBlock: @escaping (GetWorkersMessagesAudio) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/messages/today") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
                
                let getworkersMessages = try GetWorkersMessagesAudio(json: json, profiledict: profileDicts, timedict: timeDicts)
                DispatchQueue.main.async {
                    successBlock(getworkersMessages)
                }
            } catch {}
            }.resume()
    }
    
    func getMessagesYesterday(hoursWorkedWeekDict: [String: String], hoursWorkedTodayDict: [String: String], id: String, names: [String:String], success successBlock: @escaping (GetWorkersMessagesAudio) -> Void){
        let parameters = ["manager_id": id]

        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/messages/yesterday") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {

                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
                let getworkersMessages = try GetWorkersMessagesAudio(json: json, profiledict: [:], timedict: [:])
                DispatchQueue.main.async {
                    successBlock(getworkersMessages)
                }
            } catch {}
            }.resume()
    }

    func getWorkersProfile(id: String, success successBlock: @escaping (GetWorkersProfile) -> Void){
        let parameters = ["manager_id": id]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/users/roster_workers") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        session.dataTask(with: request) { (mdata, response, error) in
            guard let mdata = mdata  else {return}
            do {
                guard let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as? JSON else {return}
                //                print("this is json for get user profile users", json)
                let getworkersResponse = try GetWorkersProfile(json: json)
                DispatchQueue.main.async {
                    successBlock(getworkersResponse)
                }
            } catch {}
            }.resume()
    }
    //todays_hours.txt
    // get hours today and week
//    func downloadUsersHoursToday () {
//        let transferManager2 = AWSS3TransferManager.default()
//        let s3bucket = "wlw-jobmarket/korok@tamu.edu"  //\(UserDefaults.standard.object(forKey: "email") ?? "nil")
//        let key = "todays_hours.txt"
//        let downloadingFileURL2 = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("todHours.txt")
//
//        if let downloadRequest2 = AWSS3TransferManagerDownloadRequest() {
//
//            downloadRequest2.bucket = s3bucket
//            downloadRequest2.key = key
//            downloadRequest2.downloadingFileURL = downloadingFileURL2
//
//            transferManager2?.download(downloadRequest2).continue({ (task: AWSTask<AnyObject>) -> Any? in
//                if let error = task.error {
//                    print(error)
//                } else {
//                    print(task.result)
//                }
//                return nil
//            })
//        }
//
//        var readString: String = ""
//        do {
//            readString = try String(contentsOf: downloadingFileURL2, encoding: String.Encoding.utf8)
//            let reading = readString.components(separatedBy: "\n") as [String]
//
//            for i in 0...reading.count - 1{
//                let redLine = reading[i].components(separatedBy: ":")
//                if redLine.count > 1 {
//                    hoursWorkedTodayDict["\(redLine[0])"] = "\(redLine[1])"
//                }
//
//            }
//        } catch let error as NSError{
//            print("file stuff didnt work cus\n", error)
//        }
//
//
//    }
//
//
//    func downloadUsersHoursWeek() {
//        let transferManager2 = AWSS3TransferManager.default()
//        let s3bucket = "wlw-jobmarket/korok@tamu.edu"  //\(UserDefaults.standard.object(forKey: "email") ?? "nil")
//        let key = "current_week_hours.txt"
//        let downloadingFileURL2 = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("currWeekHrs.txt")
//
//        if let downloadRequest2 = AWSS3TransferManagerDownloadRequest() {
//
//            downloadRequest2.bucket = s3bucket
//            downloadRequest2.key = key
//            downloadRequest2.downloadingFileURL = downloadingFileURL2
//
//            transferManager2?.download(downloadRequest2).continue({ (task: AWSTask<AnyObject>) -> Any? in
//                if let error = task.error {
//                    print(error)
//                } else {
//                    print(task.result)
//                }
//                return nil
//            })
//        }
//
//        var readString: String = ""
//        do {
//            readString = try String(contentsOf: downloadingFileURL2, encoding: String.Encoding.utf8)
//            let reading = readString.components(separatedBy: "\n") as [String]
//
//            for i in 0...reading.count - 1{
//                let redLine = reading[i].components(separatedBy: ":")
//                if redLine.count > 1 {
//                    hoursWorkedWeekDict["\(redLine[0])"] = "\(redLine[1])"
//                }
//
//            }
//        } catch let error as NSError{
//            print("file stuff didnt work cus\n", error)
//        }
//
//    }
    
}
