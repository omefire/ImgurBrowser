//
//  AboutController.swift
//  starter
//
//  Created by omefire on 26/05/2016.
//  Copyright © 2016 omefire. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var version: UILabel!
    
    @IBOutlet weak var build: UILabel!
    
    var authorName = "OMefireSoft"
    var authorEmail = "contact@omefiresoft.com"
    var appVersion = "1.0"
    var buildTime = "1.5 seconds"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = authorName
        email.text = authorEmail
        version.text = appVersion
        build.text = buildTime
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
