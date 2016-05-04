//
//  ViewController.swift
//  APOD
//
//  Created by C4Q on 5/2/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
     var avPlayer: AVAudioPlayer!
    
    @IBOutlet weak var podImageView: UIImageView!
    @IBOutlet weak var podTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.podTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
      getPodJSON()
    }
    
    @IBAction func sodButtonPressed(sender: AnyObject) {
        getSodJSON()
    }
    
    
    let podURL = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
    
    
    func getPodJSON() {
        let url = NSURL(string: podURL)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                let swiftyJSON = JSON(data:data!)
                
                let podUrl = swiftyJSON["url"].stringValue
                let url = NSURL(string: podUrl)
                
                let podText = swiftyJSON["explanation"].stringValue
                
                let data = NSData(contentsOfURL: url!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.podImageView.image = UIImage(data: data!)
                    self.podTextView.text = podText
                })
                
            } else {
                print("there was an error")
            }
        }
        task.resume()
    }
    
    
    
    
    let sodUrl = "https://api.nasa.gov/planetary/sounds?q=apollo&api_key=DEMO_KEY"
    
 func getSodJSON() {
        let url = NSURL(string: sodUrl)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil {
                let swiftyJSON = JSON(data:data!)
                
                let resultsCount = swiftyJSON["results"].count
                print(resultsCount)
                let randomIndex = Int(arc4random_uniform(UInt32(resultsCount)))
                print(randomIndex)
                
                
                let streamUrl = swiftyJSON["results"][randomIndex]["stream_url"].stringValue
                let urlWClient = streamUrl + "?client_id=a3679e6542ad2a5adfc3d54e12024254"
                let url = NSURL(string: urlWClient)
                
                let data = NSData(contentsOfURL: url!)
                if let audio = data {
                    
                    do {
                        self.avPlayer = try AVAudioPlayer(data: audio)
                        print(data)
                        self.avPlayer!.prepareToPlay()
                        // audioPlayer.delegate = self
                        self.avPlayer!.play()
                    } catch {
                        print("Couldn't create player")
                    }
                } else {
                    print(error)
                }
                
            } else {
                print("there was an error")
            }
        }
        task.resume()
    }



}