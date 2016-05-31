//
//  ViewController.swift
//  starter
//
//  Created by omefire on 20/05/2016.
//  Copyright © 2016 omefire. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var catController: UISegmentedControl!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var sortController: UISegmentedControl!
    
    @IBOutlet weak var windowController: UISegmentedControl!
    
    @IBOutlet weak var viralController: UISwitch!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var about: UIButton!
    
    let baseURL = "https://api.imgur.com/3/gallery"
    var section = "/hot"
    var sort = "/viral"
    var window = "/day"
    var viralState = "?showViral=true"
    
    var imagesArray = [UIImage]()
    var titlesArray = [String]()
    var descArray = [String]()
    var upArray = [String]()
    var downArray = [String]()
    var scoreArray = [String]()
    
    // ToDO: save these in a file that will NOT be checked into git
    // Then, how do they run the source code ? retrieve this from a service ?
    let authParameters = [
        "client_id": "30e7e7c1e3abd39",
        "client_secret": "ee7caab32f4faf0692b555355c5d3eaa02bb5fea"
    ]
    
    func prepareRequestURL () -> String {
        return baseURL + section + sort + window + viralState
    }
    
    func fetchImages() {
        self.loader.startAnimating()
        
        let headers = [
            "Authorization": "Client-ID" + " " + self.authParameters["client_id"]!
        ]
        
        let request = Alamofire.request(.GET, self.prepareRequestURL(), headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    do {
                        let datas = JSON["data"]
                        try self.processImgurAPIResults(datas!!)
                    } catch {
                        self.displayErrorMessageToUser("An error occurred while processing Imgur results!")
                    }
                case .Failure(let error):
                    self.displayErrorMessageToUser(error.localizedDescription)
                }
                
                defer {
                    self.loader.stopAnimating()
                }
        }
        
    }
    
    func displayErrorMessageToUser(errorMessage: String) {
        let alert = UIAlertView()
        alert.title = "Sorry, an error occurred while fetching Imgur's images"
        alert.message = errorMessage
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    // ToDO: Implement pagination, Don't just limit ourselves to 24 images
    func processImgurAPIResults (datas: AnyObject) throws { // ToDO: Should it be cast to type array ?
        
        // For Testing purposes: 
        // Simulate a runtime error and make sure we handle it correctly
        // ... by displaying correct info to the user
        //enum Err: ErrorType {
        //    case A
        //    case B
        //}
        //throw Err.A
        
        if datas.count == 3 { // ToDO: Why?
            let error = datas["error"] as! NSString
            self.label.text = error as String
        } else {
            self.imagesArray = [UIImage]()
            self.titlesArray = [String]()
            
            var index = 0
            
            while self.imagesArray.count < 24 && index < datas.count {
                let array = datas[index]
                
                let str = array["link"] as! NSString
                let url = NSURL(string: str as String)
                let data = NSData(contentsOfURL: url!)
                
                if data != nil {
                    let image = UIImage(data:data!)
                    if image != nil {
                        self.imagesArray.insert(image!, atIndex: self.imagesArray.count)
                        self.titlesArray.insert(array["title"] as! String, atIndex: self.titlesArray.count)
                        
                        let score = array["score"] as! NSNumber
                        let ups = array["ups"] as! NSNumber
                        let downs = array["downs"] as! NSNumber
                        let description = "No Description!"
                        
                        self.scoreArray.insert("\(score)", atIndex: self.scoreArray.count)
                        self.upArray.insert("\(ups)", atIndex: self.upArray.count)
                        self.downArray.insert("\(downs)", atIndex: self.downArray.count)
                        self.descArray.insert(description, atIndex: self.descArray.count)
                    }
                } else {
                    index = index + 1
                    continue
                }
                index = index + 1
            }
            
            // Reload the view in order to use the data we just fetched from Imgur
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = ""
        
        self.fetchImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSection(sender: AnyObject) {
        switch(catController.selectedSegmentIndex) {
        case 0:
            section = "/hot"
            break
        case 1:
            section = "/top"
            break
        case 2:
            section = "/user"
            break
        default:
            break
        }
        
        self.fetchImages()
    }
    
    @IBAction func changeSort(sender: AnyObject) {
        switch(sortController.selectedSegmentIndex) {
        case 0:
            sort = "/viral"
            break
        case 1:
            sort = "/top"
            break
        case 2:
            sort = "/time"
            break
        default:
            break
        }
        
        self.fetchImages()
    }
    
    @IBAction func changeWindow(sender: AnyObject) {
        switch(windowController.selectedSegmentIndex) {
        case 0:
            window = "/day"
            break
        case 1:
            window = "/week"
            break
        case 2:
            window = "/month"
            break
        case 3:
            window = "/year"
            break
        case 4:
            window = "/all"
            break
        default:
            break
        }
        
        self.fetchImages()
    }
    
    @IBAction func viralImages(sender: AnyObject) {
        if viralController.on {
            viralState = "?showViral=true"
        } else {
            viralState = "?showViral=false"
        }
        
        self.fetchImages()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.imageView?.image = self.imagesArray[indexPath.row]
        cell.imageLabel?.text = self.titlesArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushDetails" {
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let vc = segue.destinationViewController as! NewViewController
            
            vc.image = self.imagesArray[indexPath.row]
            vc.title = self.titlesArray[indexPath.row]
            
            vc.descriptionString = self.descArray[indexPath.row]
            vc.upvoteString = self.upArray[indexPath.row]
            vc.downvoteString = self.downArray[indexPath.row]
            vc.scoreString = self.scoreArray[indexPath.row]
        }
        
        if segue.identifier == "about" {
            let about = segue.destinationViewController as! AboutController
            
            about.title = "About"
        }
    }
    
    @IBAction func showAbout(sender: AnyObject) {
        self.performSegueWithIdentifier("about", sender: self)
    }
}

