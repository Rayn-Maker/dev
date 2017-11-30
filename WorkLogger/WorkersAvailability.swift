//
//  MessageVC.swift
//  WorkLoggerWebCopy
//
//  Created by Radiance Okuzor on 11/7/17.
//  Copyright © 2017 MIRC. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google

class WorkerAvailability: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var todaysAvailTableView: UITextView!
    @IBOutlet weak var tomsAvailTableView: UITextView!
    @IBOutlet weak var weeksAvailTableView: UITextView!
    @IBOutlet weak var idleTableView: UITextView!
    
   
    
    // selected segment
    var selectedSegment = 0
    @IBAction func selectedSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.todaysAvailTableView.isHidden = false
            self.tomsAvailTableView.isHidden = true
            self.weeksAvailTableView.isHidden = true
            self.idleTableView.isHidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.todaysAvailTableView.isHidden = true
            self.tomsAvailTableView.isHidden = false
            self.weeksAvailTableView.isHidden = true
            self.idleTableView.isHidden = true
        } else if sender.selectedSegmentIndex == 2 {
            self.todaysAvailTableView.isHidden = true
            self.tomsAvailTableView.isHidden = true
            self.weeksAvailTableView.isHidden = false
            self.idleTableView.isHidden = true
        } else if sender.selectedSegmentIndex == 3 {
            self.todaysAvailTableView.isHidden = true
            self.tomsAvailTableView.isHidden = true
            self.weeksAvailTableView.isHidden = true
            self.idleTableView.isHidden = false
        }
    }
    var profileDict = [Int:[String:Any]]()
    var timeDict = [Int:[String:Any]]()
    var todaysAvailableWorkers = [RaWorkerLogs2]()
    var tomorrowsAvailableWorker = [RaWorkerLogs2]()
    var weeksAvailableWorker = [RaWorkerLogs2]()
    var idleAvailableWorker = [RaWorkerLogs2]()
    var userEmail: String = ""
    var id: String = ""
    var curWorkersDict = [String: String]()
    var availabilityArr = [String: [String]]()
    var nameDict = [String: String]()
    
    // *************************************************************************\\
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email:String = UserDefaults.standard.object(forKey: "email") as? String {
            self.userEmail = email
            print("This is the proven email: ", self.userEmail)
        }
        if let id:String = UserDefaults.standard.object(forKey: "id") as? String {
            self.id = id
            print("This is the proven id: ", self.id)
        }
        
        // get todays available workers
        MyNetworkingService.shared.getWorkersProfile(id: self.id, success: { (response) in
            self.profileDict = response.profileDict

            MyNetworkingService.shared.availabilityTodayToday(profileDict: self.profileDict, id: self.id, success: { (response) in
                self.todaysAvailableWorkers = response.raWorker2Array
                self.todaysAvailTableView.text = response.infoString
            })

        })
        
//         get tomorrows worker availabilty
            MyNetworkingService.shared.getWorkersProfile(id: self.id, success: { (response) in
                self.profileDict = response.profileDict

                MyNetworkingService.shared.availabilityTomorrowTomorrow(profileDict: self.profileDict, id: self.id, success: { (response) in
                    self.tomorrowsAvailableWorker = response.raWorker2Array
                    self.tomsAvailTableView.text = response.infoString
                })

            })
        
        
        // get week's worker availabitlity
        
        MyNetworkingService.shared.getWorkersProfile(id: self.id, success: { (response) in
            self.profileDict = response.profileDict
        
            MyNetworkingService.shared.availabilityWeekWeek(profileDict: self.profileDict, id: self.id, success: { (response) in
                self.weeksAvailableWorker = response.raWorker2Array
                self.weeksAvailTableView.text = response.infoString
            })
        
        })
    
//         idle availabilty
        MyNetworkingService.shared.getWorkersProfile(id: self.id, success: { (response) in
            self.profileDict = response.profileDict
            
            MyNetworkingService.shared.availabilityTomorrowTomorrow(profileDict: self.profileDict, id: self.id, success: { (response) in
                self.idleAvailableWorker = response.raWorker2Array
                self.idleTableView.text = response.infoString
                
            })
            
        })
        
    ///****** Make calls to pass data over.
        MyNetworkingService.shared.availabilityToday(id: self.id) { (response) in
            self.availabilityArr = response.availability
//            UserDefaults.standard.set(self.availabilityArr, forKey: "availArray")
        }
        
        MyNetworkingService.shared.getCurrentWorkers(id: self.id) { (response) in
            self.curWorkersDict = response.rpofileDict
//            UserDefaults.standard.set(self.curWorkersDict, forKey: "currWorkersDict")
        }
        MyNetworkingService.shared.getWorkersProfile(id: self.id) { (response) in
            self.nameDict = response.rpofileDict
//            UserDefaults.standard.set(self.nameDict, forKey: "nameDict")
            
        }
        
        
    }
    // *************************************************************************\\
    
    @IBAction func openMenu(_ sender: Any) {
        if menuView.isHidden == true {
            menuView.isHidden = false
        } else {
            menuView.isHidden = true
        }
    }
    
    @IBAction func signOut(_ sender: Any){
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "workersAvailabilityToSignIn", sender: nil)
    }
    
    @IBAction func workersLogPressed(_ sender: Any){
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier: "workersAvailToLogs", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workersAvailToLogs" {
            let vc = segue.destination as! WorkerLogs
    //            let indexPath = tableView.indexPathForSelectedRow
    //            vc.orgHomeInfo.prayerTitle = organization[(indexPath!.row)].prayerTitle   // Org Name
            vc.curWorkersDict = self.curWorkersDict
            vc.nameDict = self.nameDict
            vc.availabilityArr = self.availabilityArr
        }
    }
    
}


