
import Foundation

/*
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
 
 class WorkerLogs: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
 @IBOutlet weak var menuView: UIView!
 
 //****** TableViews && Labels
 @IBOutlet weak var todayTableView: UITableView!
 @IBOutlet weak var todaysLabel: UILabel!
 @IBOutlet weak var activeTableView: UITableView!
 @IBOutlet weak var activeLabel: UILabel!
 @IBOutlet weak var previousTableView: UITableView!
 @IBOutlet weak var previousLabel: UILabel!
 @IBOutlet weak var yesterdayTableView: UITableView!
 @IBOutlet weak var yesterDayLabel: UILabel!
 
 // selected segment
 var selectedSegment = 0
 @IBAction func selectedSegment(_ sender: UISegmentedControl) {
 if sender.selectedSegmentIndex == 0 {
 self.todayTableView.isHidden = false
 self.todaysLabel.isHidden = false
 self.previousTableView.isHidden = true
 self.previousLabel.isHidden = true
 self.activeLabel.isHidden = true
 self.activeTableView.isHidden = true
 self.yesterdayTableView.isHidden = true
 self.yesterDayLabel.isHidden = true
 } else if sender.selectedSegmentIndex == 1 {
 self.todayTableView.isHidden = true
 self.todaysLabel.isHidden = true
 self.previousTableView.isHidden = true
 self.previousLabel.isHidden = true
 self.activeTableView.isHidden = false
 self.activeLabel.isHidden = false
 self.yesterdayTableView.isHidden = true
 self.yesterDayLabel.isHidden = true
 } else if sender.selectedSegmentIndex == 2 {
 self.todayTableView.isHidden = true
 self.todaysLabel.isHidden = true
 self.previousTableView.isHidden = false
 self.previousLabel.isHidden = false
 self.activeTableView.isHidden = true
 self.activeLabel.isHidden = true
 self.yesterdayTableView.isHidden = true
 self.yesterDayLabel.isHidden = true
 } else if sender.selectedSegmentIndex == 3 {
 self.todayTableView.isHidden = true
 self.todaysLabel.isHidden = true
 self.previousTableView.isHidden = true
 self.previousLabel.isHidden = true
 self.activeTableView.isHidden = true
 self.activeLabel.isHidden = true
 self.yesterdayTableView.isHidden = false
 self.yesterDayLabel.isHidden = false
 }
 }
 
 //************************************* Functions to connect to network ********************************************************
 var messagesData_yesterday_Array = [RaWorkData]()
 
 
 // get User email
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
 self.messagesData_yesterday_Array.append(raworkdata)
 print("this is ma id ", self.messagesData_yesterday_Array[0].user_id!)
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
 self.yesterdayTableView.reloadData()
 self.activeTableView.reloadData()
 self.previousTableView.reloadData()
 self.todayTableView.reloadData()
 }
 
 
 
 //************************************* Functions to connect to network ********************************************************
 var userEmail: String = ""
 
 //||||\\\\\\\^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//||||\\\\\\\
 override func viewDidLoad() {
 super.viewDidLoad()
 
 getAuth() // get user id with email.
 getMesagesYesterday()
 
 // user email
 if let email:String = UserDefaults.standard.object(forKey: "email") as? String {
 userEmail = email
 }
 print("This is user emial ",userEmail)
 
 }
 //||||\\\\\\\^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//||||\\\\\\\
 
 @IBAction func openMenu(_ sender: Any) {
 if menuView.isHidden == true {
 menuView.isHidden = false
 } else {
 menuView.isHidden = true
 }
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 if tableView == yesterdayTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "yesterDayCell", for: indexPath) as! RaDataCell
 cell.fnameLabel.text = "\(self.messagesData_yesterday_Array[indexPath.row].user_id)"
 cell.dataTextLbl.text = "\(self.messagesData_yesterday_Array[indexPath.row].data)"
 print("Theis are cell for rows: ", (cell.dataTextLbl.text) + (cell.fnameLabel.text)!)
 return cell
 } else if tableView == activeTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "activeCell", for: indexPath) as! RaDataCell
 cell.activeData.text = "\(self.messagesData_yesterday_Array[indexPath.row].data)"
 cell.activeFname.text = "\(self.messagesData_yesterday_Array[indexPath.row].user_id)"
 return cell
 } else if tableView == previousTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "previousCell", for: indexPath) as! RaDataCell
 cell.previousFname.text = "\(self.messagesData_yesterday_Array[indexPath.row].user_id)"
 cell.previousData.text = "\(self.messagesData_yesterday_Array[indexPath.row].data)"
 return cell
 } else if tableView == todayTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! RaDataCell
 cell.todayData.text = "\(self.messagesData_yesterday_Array[indexPath.row].data)"
 cell.todayFnameLbl.text = "\(self.messagesData_yesterday_Array[indexPath.row].user_id)"
 return cell
 }
 else {
 let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! RaDataCell
 cell.todayData.text = "\(self.messagesData_yesterday_Array[indexPath.row].user_id)"
 cell.todayFnameLbl.text = "\(self.messagesData_yesterday_Array[indexPath.row].data)"
 return cell
 }
 
 }
 
 func numberOfSections(in tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 if tableView == yesterdayTableView {
 return messagesData_yesterday_Array.count
 } else if tableView == activeTableView {
 return messagesData_yesterday_Array.count
 } else if tableView == previousTableView {
 return messagesData_yesterday_Array.count
 } else if tableView == todayTableView {
 return messagesData_yesterday_Array.count
 }
 else {
 return messagesData_yesterday_Array.count
 }
 }
 }
 
 //extension WorkerAvailability: UITableViewDataSource, UITableViewDelegate {
 //
 //
 //
 //}
 
 //
 //  MessageVC.swift
 //  WorkLoggerWebCopy
 //
 //  Created by Radiance Okuzor on 11/7/17.
 //  Copyright © 2017 MIRC. All rights reserved.
 //
 
 import UIKit
 
 class MessageVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
 
 @IBOutlet weak var menuView: UIView!
 @IBOutlet weak var todaysAvailTableView: UITableView!
 @IBOutlet weak var tomsAvailTableView: UITableView!
 @IBOutlet weak var weeksAvailTableView: UITableView!
 @IBOutlet weak var idleTableView: UITableView!
 
 var gerAvailabilityTodayArray = [RaWorkData]()
 
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
 
 func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 if tableView == todaysAvailTableView {
 return "Today's availability"
 } else if tableView == tomsAvailTableView{
 return "Tomorrow's availability"
 } else if tableView == weeksAvailTableView {
 return "Week's availability"
 } else if tableView == idleTableView {
 return "Idle"
 } else {
 return "Today's availability"
 }
 }
 
 // *************************************************************************\\
 override func viewDidLoad() {
 super.viewDidLoad()
 
 }
 // *************************************************************************\\
 
 @IBAction func openMenu(_ sender: Any) {
 if menuView.isHidden == true {
 menuView.isHidden = false
 } else {
 menuView.isHidden = true
 }
 }
 
 func numberOfSections(in tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 if (tableView == todaysAvailTableView) {
 print("this is the gerav count",gerAvailabilityTodayArray.count)
 return self.gerAvailabilityTodayArray.count ?? 0
 } else if (tableView == tomsAvailTableView) {
 return 1
 } else if (tableView == weeksAvailTableView) {
 return 1
 } else if (tableView == idleTableView) {
 return 1
 } else {
 return 1
 }
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 if tableView == idleTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "idleCell", for: indexPath) as! RaDataCell
 cell.idleFnameWrkrAvail.text = "CHange"
 cell.idleDurationWrkrAvail.text = "change"
 return cell
 } else if tableView == tomsAvailTableView{
 let cell = tableView.dequeueReusableCell(withIdentifier: "tomAvailCell", for: indexPath) as! RaDataCell
 cell.tomFnameWrkrAvail.text = "change"
 cell.tomDurationWrkrAvail.text = "change"
 return cell
 } else if tableView == weeksAvailTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "weeksAvailCell", for: indexPath) as! RaDataCell
 cell.weekFnameWrkrAvail.text = "change"
 cell.weekDurationWrkrAvail.text = "change"
 return cell
 } else if tableView == todaysAvailTableView {
 let cell = tableView.dequeueReusableCell(withIdentifier: "todaysAvail", for: indexPath) as! RaDataCell
 cell.todayFnameWrkrAvail.text = "welp"//"\(self.gerAvailabilityTodayArray[indexPath.row].user_id) todays available name"
 cell.todayDurationWrkrAvail.text = "o welp"//"\(self.gerAvailabilityTodayArray[indexPath.row].start) \(self.gerAvailabilityTodayArray[indexPath.row].end) today's available duration"
 print("\(self.gerAvailabilityTodayArray[indexPath.row].user_id) ")
 return cell
 } else {
 let cell = tableView.dequeueReusableCell(withIdentifier: "idleCell", for: indexPath) as! RaDataCell
 cell.idleFnameWrkrAvail.text = "CHange"
 cell.idleDurationWrkrAvail.text = "change"
 return cell
 }
 }
 
 
 // **************************Connect to server************************************************\\
 
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
 DispatchQueue.main.async {
 self.gerAvailabilityTodayArray.removeAll()
 let raworkdata = RaWorkData()
 for ras in rjson! {
 raworkdata.user_id = ras["user_id"]
 raworkdata.start = ras["start"]
 raworkdata.end = ras["end"]
 self.gerAvailabilityTodayArray.append(raworkdata)
 print("this is ma first start ", self.gerAvailabilityTodayArray[0].start)
 print("this is ma first id ", self.gerAvailabilityTodayArray[0].user_id)
 print("this is ma first end ", self.gerAvailabilityTodayArray[0].end)
 
 }
 print("\nthis is ger count ", self.gerAvailabilityTodayArray.count)
 print(" -----")
 }
 
 
 } catch {
 print(error)
 }
 
 }
 
 }.resume()
 self.todaysAvailTableView.reloadData()
 }
 
 }

 
 */*/*/*/
