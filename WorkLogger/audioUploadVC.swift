//
//  audioUploadVC.swift
//  WorkLogger
//
//  Created by Radiance Okuzor on 11/29/17.
//  Copyright © 2017 MIRC. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AWSS3
import GoogleSignIn
import Google

class audioUploadVC: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var timeDict = [Int:[String:Any]]()
    var timeDict2 = [Int:[String:Any]]()
    var profileDict = [Int:[String:Any]]()
    var profileDict2 = [Int:[String:Any]]()
    var todaysWorkerLogs = [RaWorkerLogs2]()
    var workers = [RaWorkerLogs2]()
    var wor = RaWorkerLogs2()
    var workerNill = RaWorkerLogs2()
    var id: String = ""
    var names = [String:String]()
    var messageAndProfil = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        workerNill.name = " "
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermision) in
            if hasPermision{
                print("have per")
            }
        }
        
        if let id:String = UserDefaults.standard.object(forKey: "id") as? String {
            self.id = id
        }
        
                if let messages:String = UserDefaults.standard.object(forKey: "todaysMess") as? String {
                    DataInfoStringText.text = messages
                }
        
                if let names:[String:String] = UserDefaults.standard.object(forKey: "nameDict") as? [String:String] {
                    self.names = names
                }
        
        //        workerStuff
        
        
        for (x,y) in names {
            wor.name = y
           
            
            workers.append(wor)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGroupTapped(_ sender: UISwitch) {
        if sender.isOn == true {
            primaryText.text = "ALL"
            primaryText.isEnabled = false
            flName.text = "No Hours Today For Top Person"
            secondaryText.text = " "
            secondaryText.isEnabled = false
            namesDrpDwn2.isHidden = true
            namesDrpDwn.isHidden = true
        } else {
            primaryText.text = ""
            primaryText.isEnabled = true
            flName.text = ""
            secondaryText.text = " "
            secondaryText.isEnabled = true
        }
    }
    
    @IBOutlet weak var primaryText: UITextField!
    
    @IBOutlet weak var flName: UILabel!
    @IBOutlet weak var namesDrpDwn: UIPickerView!
    @IBOutlet weak var namesDrpDwn2: UIPickerView!
    
    @IBOutlet weak var secondaryText: UITextField!
    
    var urgency: String = "HIGH"
    var primSec: String = "P"
    @IBAction func urgencyToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            urgency = "HIGH"
        } else if sender.selectedSegmentIndex == 1 {
            urgency = "LOW"
        } else if sender.selectedSegmentIndex == 2 {
            urgency = "URGENT"
        }
    }
    
    
    @IBOutlet weak var DataInfoStringText: UITextView!
    
    @IBOutlet weak var menuView: UIView!
    
    
    @IBAction func openMenu(_ sender: Any) {
        if menuView.isHidden == true {
            menuView.isHidden = false
        } else {
            menuView.isHidden = true
        }
    }
    
    @IBAction func signOut(_ sender: Any){
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "workersTabToSignIn2", sender: nil)
    }
    
    
    func  uploadFile(withResources: String, type: String){
        
    }
    
    
    @IBAction func uploadTaped(){
        if primaryText.text != " " || secondaryText.text != " "  {
            if primaryText.text != " "  {
                self.primSec = "P"
                uploadMe(recepientName: primaryText.text!)
            }
            if secondaryText.text != " " {
                self.primSec = "S"
                uploadMe(recepientName: secondaryText.text!)
            }
        } else {
            print("need recepients field filled")
        }
    }
    
    @IBAction func onBulkTaped(){
        
    }
    
    @IBOutlet weak var newRecording: UIButton!
    @IBOutlet weak var pauseRecBtn: UIButton!
    @IBOutlet weak var contRecBtn: UIButton!
    
    // Set up Audio Stuff
    // variables for audio set
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var numberOfRecords: Int = 0
    var audiofilename: String = ""
    var audioPlayer: AVAudioPlayer!
    
    @IBAction func recPrsd(_ sender: Any) {
        let transferManager = AWSS3TransferManager.default()
        if audioRecorder == nil {
            let myFile = getDire().appendingPathComponent("audiofromIphone.m4a")
            //            getDire().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey:1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            do{
                audioRecorder = try AVAudioRecorder(url: myFile, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
            } catch {
                
            }
            
        } else {
            // stop audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            
        }
    }
    
    func uploadMe(recepientName: String) {
        
        let transferManager = AWSS3TransferManager.default()
        let path = getDire().appendingPathComponent("audiofromIphone.m4a")
        let uploadingFileURL = path
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest?.bucket = "wlw-jobmarket/korok@tamu.com/Audio Files"
        uploadRequest?.key = "\(recepientName) \(getTimeStamp()) - \(self.primSec) - \(urgency).m4a"
        uploadRequest?.body = uploadingFileURL
        
        transferManager.upload(uploadRequest!).continueWith {  (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uplod successful )")
            }
            return nil
        }
        
                transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
                    if let error = task.error {
                        print(error)
                    }
                    if task.result != nil {
                        print("Uplod successful )")
                    }
                    return nil
                }
    }
    
    
    // File Manager
    func getDire() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // searching for all urls in document directory
        let documentDir = paths[0] // take the first one as our path
        return documentDir // location of stored recordings
    }
    func getDocumentsDirectory() -> URL {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask) // all the user's document directories
        let docsURL = dirPaths[0] // documents path
        return docsURL
    }
    
    func getAudioFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(".m4a")
    }
    
    func getTimeStamp() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        var hour = components.hour
        let minute = components.minute
        var monthVar: String = ""
        var amPm: String = "AM"
        
        switch month {
        case 1?:
            monthVar =  "January"
        case 2?:
            monthVar =  "February"
        case 3?:
            monthVar =  "March"
        case 4?:
            monthVar =  "April"
        case 5?:
            monthVar =  "May"
        case 6?:
            monthVar =  "June"
        case 7?:
            monthVar =  "July"
        case 8?:
            monthVar =  "August"
        case 9?:
            monthVar =  "September"
        case 10?:
            monthVar =  "October"
        case 11?:
            monthVar =  "November"
        case 12?:
            monthVar =  "December"
        default:
            monthVar = "NillMonth"
        }
        
        if hour! >= 12{
            hour = hour! - 12
            if hour! == 0 {
                hour! = 12
            }
            amPm = "PM"
        }
        
        return "\(monthVar) \(day ?? 0), \(year ?? 0) \(hour ?? 0):\(minute ?? 0)\(amPm) CST"
    }
    
    func getMessages(){
        for x in 0...todaysWorkerLogs.count - 1 {
            for y in 0...workers.count - 1 {
                if "\(todaysWorkerLogs[x].name)" == "\(workers[y].name)" {
                    self.DataInfoStringText.text = todaysWorkerLogs[x].dataString
                }
            }
        }
    }
    
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == namesDrpDwn2 {
                return "\(workers[row].name ?? "")"
            }
            else if pickerView == namesDrpDwn {
                return "\(workers[row].name ?? "")"
            } else {
                return "\(workers[row].name ?? "")"
            }
    
        }
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            if pickerView == namesDrpDwn2 {
                return 1
            }
            else if pickerView == namesDrpDwn {
                return 1
            } else {
                return 1
            }
        }
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
            if pickerView == namesDrpDwn2 {
                 return self.workers.count
            }
            else if pickerView == namesDrpDwn {
                 return self.workers.count
            } else {
                 return self.workers.count
            }
    
        }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == namesDrpDwn {
                primaryText.text = "\(workers[row].name ?? "")"
                flName.text = "\(workers[row].name ?? "0") \n \(workers[row].startTime ?? "0") \(workers[row].endTime ?? "0") "
//                self.DataInfoStringText.text = "\(workers[row].dataString ?? "No Messages for the selected worker")"
                self.namesDrpDwn.isHidden = true
            }
            if pickerView == namesDrpDwn2 {
    //            flName.text = "\(workers[row].name ?? "0") - \(workers[row].startTime ?? "0") \(workers[row].endTime ?? "0") "
                secondaryText.text = "\(workers[row].name ?? "")"
    //            self.DataInfoStringText.text = "\(workers[row].dataString)"
                self.namesDrpDwn2.isHidden = true
            }
        }
    
    
         func textFieldDidBeginEditing(_ textField: UITextField){
            if textField == primaryText {
                self.namesDrpDwn.isHidden = false
                self.view.endEditing(true)
            }
            if textField == secondaryText {
                self.namesDrpDwn2.isHidden = false
                self.view.endEditing(true)
            }
    
      }

}
