//
//  sampleURLSession.swift
//  WorkLoggerWebCopy
//
//  Created by Radiance Okuzor on 11/8/17.
//  Copyright © 2017 MIRC. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google



class sampleURLSession: UIViewController {
    
    var userID: String! // brings back a number
    var userName: String!
    var userEmail: String!
    var currUsers = [String]() // brings back an array
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var spicy: String!
    var workDataArray = [RaWorkData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

// ************** Google sign in stufff
//        var error: NSError?
//        GGLContext.sharedInstance().configureWithError(&error)
//        if error != nil{
//            print(error)
//        }
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
//        let googleSignInButton = GIDSignInButton()
//        googleSignInButton.center = view.center
//        view.addSubview(googleSignInButton)
//    ************** End Google Sign in stuff
        
        // save the user emaail
//        if let email:String = UserDefaults.standard.object(forKey: "email") as? String {
//            userEmail = email
//        }
        print("This is user emial ",userEmail)
        
        //        getStuff()

    }
    
    // sign in with google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print (error)
        } else {
            userEmail = user.profile.email
            UserDefaults.standard.set(userEmail, forKey: "email")
            let url = user.profile.imageURL(withDimension: 10)
            let stringURL = url?.absoluteString
            picture.downloadImage(from: stringURL!)
//            print("This is the user's Email: \(userEmail!)" )
            label.text = userEmail
        }
    }

   
    // post to api
    func getAuth() {
        
        let parameters = ["email": "korok@tamu.edu"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/worker_sessions/get_auth") // for post requests use post
            else { print("Autho didnt work "); return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    guard let array = json as? [String:Any] else { return }

                    guard let response = array["response"] as? [String: Any] else {print("Not a dict "); return}
                    guard let userId = response["id"] as? Int else {print("Not a Int "); return}
                        
                    print("*****User ID is: \(userId)")
                   
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    
    func getCurrentUsers() {
        
        let parameters = ["manager_id": "120"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/worker_sessions/current_users") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                   print("Json for current users")
                    print(json)
                    guard let array = json as? [String:Any] else { return }
                    
                    guard let responsse = array["response"] as? String else {print("Not a dict "); return}
//                    guard let userId = response["id"] as? Int else {print("Not a Int "); return}
                    
                    print("current users response: \(responsse)")
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getAvailability() {
        
        let parameters = ["manager_id": "120"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/today") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (mdata, response, error) in
            if let response = response {
                //                print(response)
            }
            
            if let mdata = mdata {
                do {
                    let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as![String:AnyObject]
                    print("Json for getAvailability")
                    print(json)
//                    guard let array = json else { return }
                    
                    guard let responsse = json["response"] as? String  else {print("***Not a Dictt "); return}
                    print("htis i s repsone",responsse)
                    let text = responsse
                    let rdata = text.data(using: .utf8)
                    let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String:Any]]
                    print(" -----")
                    let raworkdata = RaWorkData()
                    for ras in rjson! {
                        raworkdata.user_id = ras["user_id"]
                        raworkdata.start = ras["start"]
                        raworkdata.end = ras["end"]
                        self.workDataArray.append(raworkdata)
                        print("this is ma start ", raworkdata.start)
                        print("this is ma id ", raworkdata.user_id)
                        print("this is ma end ", raworkdata.end)
                    }
                    
                    print("json count is ", rjson![0]["user_id"] )
                    print(" -----")
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    // json converter from string to dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getAvailabilityTomorrow() {
        
        let parameters = ["manager_id": "120"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/tomorrow") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Json for getAvailability tomorrow")
                    print(json)
                    guard let array = json as? [String:Any] else { return }
                    print("THis is array")
                    print(array.count)
                    guard let responsse = array["response"] as? String else {print("Not a Dictt "); return}
//                    guard let userId = array["id"] as? Int else {print("Not a Int "); return}
                    print("this is responsse for tomorrow's availabity", responsse)
//                    print("User ID is: \(userId)")
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }

    
    func getAvailabilityWeekly() {
        
        let parameters = ["manager_id": "120"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/availabilities/weekly") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (data, response, error) in
            // check error
            // check response
            if let response = response {
//                print(response)
            }
//            let url = URL(fileURLWithPath: path) // turn path to url so we can get data
//            do {
//                let data = try Data(contentsOf: url)
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) // convert data to json
//                //json is an array
//                guard let array = json as? [[String: Any]] else {return}
//                var names = [String]()
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Json for getAvailabilityWeekly")
                    print(json)
                    guard let array = json as? [String:Any] else { return }
                    print("THis is array count")
                    print(array.count)
                    guard let responsse = array["response"] as? String else {print("Not a Dictt "); return}
                    //                    guard let userId = array["id"] as? Int else {print("Not a Int "); return}
                    print("this is response for availabilty weekly")
                    print(responsse)
//                     self.spicy = "\(response)"
                    //                    print("User ID is: \(userId)")
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getMesagesToday() {
        
        let parameters = ["manager_id": "120"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/messages/today") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("this is json for today's messages")
                    print(json)
                    guard let array = json as? [String:Any] else { return }
                    
                    guard let responsse = array["response"] as? String else {print("Not a Dictt "); return}
//                    guard let userId = array["id"] as? Int else {print("Not a Int "); return}
                    
                    print("User Response is for today's messages: \(responsse)")
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func getMesagesYesterday() {
        
        let parameters = ["manager_id": "120"]
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/messages/yesterday") // for post requests use post
            else { return }
        var request = URLRequest(url: url) // must be done with a url request. not just URL
        request.httpMethod = "POST"     // this will let url session know we are doing a post request.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // parameters to be posted. value for htpp header fields which is set for the content type.
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) // turn parameters into json
            else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared  // do data task with request.
        session.dataTask(with: request) { (mdata, response, error) in
            if let response = response {
                //                print(response)
            }
            
            if let mdata = mdata {
                do {
                    let json = try JSONSerialization.jsonObject(with: mdata, options: .mutableContainers) as![String:AnyObject]
                    print("Json for getAvailability")
                    print(json)
                    //                    guard let array = json else { return }
                    
                    guard let responsse = json["response"] as? String  else {print("***Not a Dictt "); return}
                    print("htis i s repsone",responsse)
                    let text = responsse
                    let rdata = text.data(using: .utf8)
                    let rjson = try JSONSerialization.jsonObject(with: rdata!, options: .mutableLeaves) as? [[String:Any]]
                    print(" -----")
                    let raworkdata = RaWorkData()
                    for ras in rjson! {
                        raworkdata.user_id = ras["user_id"]
                        raworkdata.data = ras["data"]
                        raworkdata.audio_file_tag = ras["audio_file_tag"]
                        raworkdata.time_since_last_message = ras["time_since_last_message"]
                        raworkdata.created_at = ras["created_at"]
                        self.workDataArray.append(raworkdata)
                        print("this is ma id ", raworkdata.user_id!)
                        print("this is ma data ", raworkdata.data!)
                        print("this is ma audiofile ", raworkdata.audio_file_tag!)
                        print("this is ma time since ", raworkdata.time_since_last_message!)
                        print("this is ma created at ", raworkdata.created_at!)
                    }
                    
                    print("json count is ", rjson![0]["user_id"] )
                    print(" -----")
                    
                }  catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    
    // access api and get data back.
    func getStuff() {
        
        guard let url = URL(string: "http://www.workloggerweb.com/api/v1/") // url to get users
            else { return }
        
        let session = URLSession.shared  // url session with completion handler  to parse data giving. this is your get request
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {  // first get response back to make sure response was successful
                print(response)
            }
            
            if let data = data {   // data that you get back from response
                print(data)   // data is raw, it must be converted to json to be viewable
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])  // converts data to json
                    print(json)  // returns Json.
                } catch {
                    print(error)
                }
                
            }
            }.resume()  // .resume makes data task continue
    }
    
    
    
    // Parse Json here
    func jSonParser(){
        guard let path = Bundle.main.path(forResource: "usersAPI", ofType: "txt") else { return }
        // first access users api file. give it name of file (the name you named the file), type is extensiotn if json file then json
//        print("Path is : \(path)") // show were the path is. right now path is simply a string, what we want is the url for this path
        let url = URL(fileURLWithPath: path) // pass in path as string to get url next get data from path
        
        do {
        let data = try Data(contentsOf: url) // this gives back data in bytes so we have to do some serialization to the data
//            print(data)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//            print(json)
            
           guard let array = json as? [Any] else { return }
            
            for user in array {
               guard let userDict = user as? [String: Any]  else {return}
                guard let userId = userDict["id"] as? Int else {print("Not a string "); return}
                guard let name = userDict["name"] as? String else { return}
                guard let company = userDict["company"] as? [String: String] else {return}
                guard let companyName = company["name"] else {return}
                
                print(userId)
                print(name)
                print(companyName)
                print(" ")
            }
        } catch {
            print(error)
        }
    }
    
}


// to get id get_auth
// to get current users for manager current_users
// availability today availabilities/today


extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
    
    
}
