//
//  deletples.swift
//  WorkLogger
//
//  Created by Radiance Okuzor on 11/29/17.
//  Copyright © 2017 MIRC. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
import AWSCognito
import AWSS3


class deletples: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {

    let downloadingFileURLWeekHrs = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("weekHrsText2.txt")
    let downloadedFileURLTodayHrs = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("todayHrsText2.txt")
    var userEmail: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadUsersHoursWeek()
        downloadUsersHoursTod()
        
        // ************** Google sign in stufff
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil{
            print(error)
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.center = view.center
        //        googleSignInButton.colo
        view.addSubview(googleSignInButton)
        //    ************** End Google Sign in stuff
        
        if let email:String = UserDefaults.standard.object(forKey: "email") as? String {
            userEmail = email
            print("**userEmail is ", userEmail)
        }
        
        //        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .usEast1, identityPoolId: "us-east-1:a7d7c5f3-018b-434d-82d3-cb45ca9ea4ec")
        //        let configuration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: self.credentialProvider)
        //        AWSserviceManager.default().defaultServiceConfiguation = configuration
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print (error)
        } else {
            UserDefaults.standard.set(user.profile.email, forKey: "email") //korok@tamu.edu
            print("It worked ")
            // get User email
            
            let parameters = ["email": "korok@tamu.edu"] // change this
            
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
                        print(response)
                        guard let userId = response["id"] as? Int else {print("Not a Int "); return}
                        UserDefaults.standard.set("\(userId)", forKey: "id")
                        print("*****User ID is: \(userId)")
                        
                    } catch {
                        print(error)
                    }
                }
                
                }.resume()
            performSegue(withIdentifier: "signInToAvail", sender: nil)
        }
    }
    
    func downloadUsersHoursWeek() {
        let transferManager = AWSS3TransferManager.default()
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        let s3bucket = "wlw-jobmarket/korok@tamu.edu"  //\(UserDefaults.standard.object(forKey: "email") ?? "nil")
        let s3key = "current_week_hours.txt"
        
        downloadRequest?.bucket = s3bucket
        downloadRequest?.key = s3key
        downloadRequest?.downloadingFileURL = downloadingFileURLWeekHrs
        
        
        
        transferManager.download(downloadRequest!).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
            print("this is task result ",task.result)
        })
        
        transferManager.download(downloadRequest!).continueWith(block:  { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uplod successful \n task result is \n",task.result!)
            }
            return nil
        })
        
    }
    
    func downloadUsersHoursTod() {
        let transferManager = AWSS3TransferManager.default()
        let s3bucket = "wlw-jobmarket/korok@tamu.edu"  //\(UserDefaults.standard.object(forKey: "email") ?? "nil")
        let s3key = "todays_hours.txt"
        if let downloadRequest = AWSS3TransferManagerDownloadRequest(){
            downloadRequest.bucket = s3bucket
            downloadRequest.key = s3key
            downloadRequest.downloadingFileURL = downloadedFileURLTodayHrs
            
            transferManager.download(downloadRequest).continueWith(block: { (task: AWSTask<AnyObject>) -> Any? in
                print("this is task result ",task.result)
            })
            
            transferManager.download(downloadRequest).continueWith(block:  { (task) -> Any? in
                if let error = task.error {
                    print(error)
                }
                if task.result != nil {
                    print("Uplod successful \n task result is \n",task.result!)
                }
                return nil
            })
        }
        
    }
    
    

    @IBAction func delet(_ sender: Any) {
        print("Shit")
    }
    
}
