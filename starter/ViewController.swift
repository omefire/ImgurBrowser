//
//  ViewController.swift
//  starter
//
//  Created by Mac on 20/05/2016.
//  Copyright © 2016 Imgur. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwift
import SwiftyJSON

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
    var category = "/hot"
    var sort = "/viral"
    var window = "/day"
    var viralState = "?showViral=true"
    
    var imagesArray = [UIImage]()
    var titlesArray = [String]()
    var descArray = [String]()
    var upArray = [String]()
    var downArray = [String]()
    var scoreArray = [String]()
    
    let authParameters = [
        "client_id": "30e7e7c1e3abd39",
        "client_secret": "ee7caab32f4faf0692b555355c5d3eaa02bb5fea"
    ]
    
    func prepareRequestURL () -> String {
        return baseURL + category + sort + window + viralState
    }
    
    func fetchImages () {
        self.loader.startAnimating()
        
        let headers = [
            "Authorization": "Client-ID " + self.authParameters["client_id"]!
        ]
        
        Alamofire.request(.GET, self.prepareRequestURL(), headers: headers)
                .responseJSON { response in
                    if let JSON = response.result.value {
                        // now populate values in the arrays!
                        let datas = JSON["data"]
                        self.printResult(datas!!)
                    }
                }
    }
    
    func printResult (datas: AnyObject) {
        if datas.count == 3 {
            let error = datas["error"] as! NSString
            self.label.text = error as String
        } else {
            self.imagesArray = [UIImage]()
            self.titlesArray = [String]()
            
            var index = 0
            while self.imagesArray.count < 24 && index != datas.count {
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
            
            // reload the view in order to use datas fetch from imgur's api
            self.collectionView.reloadData()
            self.loader.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        label.text = ""
        
        // Load all images in imgur gallery
        self.fetchImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeCategory(sender: AnyObject) {
        // Let's control which category is selected by the user before making any request
        if catController.selectedSegmentIndex == 0 {
            // load hot images
            category = "/hot"
        }
        if catController.selectedSegmentIndex == 1 {
            // load top images
            category = "/top"
        }
        if catController.selectedSegmentIndex == 2 {
            // load user images
            category = "/user"
        }
        
        // get images from specified category
        self.fetchImages()
    }
    
    @IBAction func changeSort(sender: AnyObject) {
        // Let's control which sort is selected by the user before making any request
        if sortController.selectedSegmentIndex == 0 {
            // sort by viral images
            sort = "/viral"
        }
        if sortController.selectedSegmentIndex == 1 {
            // sort by top images
            sort = "/top"
        }
        if sortController.selectedSegmentIndex == 2 {
            // sort by time images
            sort = "/time"
        }
        
        // get images from specified category
        self.fetchImages()
    }
    
    @IBAction func changeWindow(sender: AnyObject) {
        // Let's control which window is selected by the user before making any request
        if windowController.selectedSegmentIndex == 0 {
            // get daily images
            window = "/day"
        }
        if windowController.selectedSegmentIndex == 1 {
            // get weekly images
            window = "/week"
        }
        if windowController.selectedSegmentIndex == 2 {
            // get monthly images
            window = "/month"
        }
        if windowController.selectedSegmentIndex == 3 {
            // get year images
            window = "/year"
        }
        if windowController.selectedSegmentIndex == 4 {
            // get all images
            window = "/all"
        }
        
        // get images from specified category
        self.fetchImages()
    }

    @IBAction func viralImages(sender: AnyObject) {
        if viralController.on {
            // display viral images
            viralState = "?showViral=true"
        } else {
            // hide viral images
            viralState = "?showViral=false"
        }
        
        // get image form specified params
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

