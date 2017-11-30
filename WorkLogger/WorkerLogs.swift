//
//  WorkerAvailability.swift
//  WorkLoggerWebCopy
//
//  Created by Radiance Okuzor on 11/7/17.
//  Copyright © 2017 MIRC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AWSS3
import AWSCognito
import AWSCore
import GoogleSignIn
import Google

class WorkerLogs: UIViewController {
    
    static let shared = WorkerLogs()
    
    @IBOutlet weak var menuView: UIView!
    
    //****** TableViews
    @IBOutlet weak var todaysLogTableView: UITextView!
    @IBOutlet weak var activeLogTableView: UITextView!
    @IBOutlet weak var previousLogTableView: UITextView!
    @IBOutlet weak var yesterdayLogTableView: UITextView!

    
    // selected segment
    var selectedSegment = 0
    @IBAction func selectedSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.todaysLogTableView.isHidden = false
            self.previousLogTableView.isHidden = true
            self.activeLogTableView.isHidden = true
            self.yesterdayLogTableView.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.todaysLogTableView.isHidden = true
            self.previousLogTableView.isHidden = true
            self.activeLogTableView.isHidden = false
            self.yesterdayLogTableView.isHidden = true
        } else if sender.selectedSegmentIndex == 2 {
            self.todaysLogTableView.isHidden = true
            self.previousLogTableView.isHidden = false
            self.activeLogTableView.isHidden = true
            self.yesterdayLogTableView.isHidden = true
        } else if sender.selectedSegmentIndex == 3 {
            self.todaysLogTableView.isHidden = true
            self.previousLogTableView.isHidden = true
            self.activeLogTableView.isHidden = true
            self.yesterdayLogTableView.isHidden = false
        }
    }
    
    var userEmail: String = ""
    var id: String = ""
    var profileDict = [Int:[String:Any]]()
    var todaysWorkerLogs = [RaWorkerLogs2]()
    var activeWorkerLogs = [RaWorkerLogs2]()
    var previousWorkerLogs = [RaWorkerLogs2]()
    var yesterdaysWorkerLogs = [RaWorkerLogs2]()
    var raWorker2Array = [RaWorkerLogs2]()
     var timeDict = [Int:[String:Any]]()
    var nameDict = [String: String]()
    var hourToday = [String: String]()
    var hourWeek = [String: String]()
    var curWorkersDict = [String: String]()
    var availabilityArr = [String: [String]]()
    var inforString: String = ""
    let downloadingFileURLWeekHrs = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("weekHrsText2.txt")
    let downloadedFileURLTodayHrs = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("todayHrsText2.txt")
    //||||\\\\\\\^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//||||\\\\\\\
    override func viewDidLoad() {
        super.viewDidLoad()
       downloadUsersHoursTod()
       downloadUsersHoursWeek()
        hourToday = stringToDict(url: downloadedFileURLTodayHrs)
        hourWeek = stringToDict(url: downloadingFileURLWeekHrs)
        // user email 
        if let email:String = UserDefaults.standard.object(forKey: "email") as? String {
            self.userEmail = email
            print("This is the proven email: ", self.userEmail)
        }
        if let id:String = UserDefaults.standard.object(forKey: "id") as? String {
            self.id = id
        }
        //get logs for the today

    
        MyNetworkingService.shared.getMessagesToday( hoursWorkedWeekDict: self.hourWeek, hoursWorkedTodayDict: self.hourToday, id: self.id, success: { (response) in
                    self.inforString = response.messageTodayString
                    self.todaysLogTableView.text = response.messageTodayString
                    self.activeLogTableView.text = response.messageActiveString
                    self.previousLogTableView.text = response.messagePreviousString
                })
            
          
        
        
        //get logs for yesterday
        MyNetworkingService.shared.getWorkersProfile(id: id) { (response) in
            self.nameDict = response.rpofileDict
            MyNetworkingService.shared.getMessagesYesterday(hoursWorkedWeekDict: self.hourWeek, hoursWorkedTodayDict: self.hourToday, id: self.id, names: self.nameDict, success: { (response) in
//                self.inforString = response.infoString
                self.yesterdayLogTableView.text = response.infoString
            })
        }

        
    }
    //||||\\\\\\\^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//||||\\\\\\\
    
    func stringToDict(url: URL) -> [String:String]{
         var nameDict = [String: String]()
        var redString = ""
        do {
            redString = try String(contentsOf: url, encoding: String.Encoding.utf8)
            let readings = redString.components(separatedBy: "\n") as [String]
            
            for i in 0...readings.count - 1{
                let redLine = readings[i].components(separatedBy: ":")
                if redLine.count > 1 {
                    nameDict["\(redLine[0])"] = "\(redLine[1])"
                }
                
            }
        } catch let error as NSError{
            print("file stuff didnt work cus\n", error)
        }
        
        return nameDict
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
    
    @IBAction func openMenu(_ sender: Any) {
        if menuView.isHidden == true {
            menuView.isHidden = false
        } else {
            menuView.isHidden = true 
        }
    }
    
    @IBAction func signOut(_ sender: Any){
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "workersLogsToSignIn", sender: nil)
    }
    
}



