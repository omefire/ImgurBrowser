//
//  NewViewController.swift
//  starter
//
//  Created by Mac on 20/05/2016.
//  Copyright © 2016 Imgur. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var upvote: UILabel!
    @IBOutlet weak var downvote: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var image = UIImage()
    var scoreString = ""
    var upvoteString = ""
    var downvoteString = ""
    var descriptionString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.descriptionText.text = self.descriptionString
        self.upvote.text = self.upvoteString
        self.downvote.text = self.downvoteString
        self.score.text = self.scoreString
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
