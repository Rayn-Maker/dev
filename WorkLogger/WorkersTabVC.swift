//
//  WorkersTabVC.swift
//  WorkLoggerWebCopy
//
//  Created by Radiance Okuzor on 11/7/17.
//  Copyright © 2017 MIRC. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import AWSS3
import AWSCognito
import AWSCore

class WorkersTabVC: UIViewController {
    
     @IBOutlet weak var menuView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        performSegue(withIdentifier: "workersTabToSignIn", sender: nil)
    }
}
