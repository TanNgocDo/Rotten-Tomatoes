//
//  MovieDetailViewController.swift
//  Rotten Tomatoes
//
//  Created by Do Ngoc Tan on 8/27/15.
//  Copyright (c) 2015 Do Ngoc Tan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet var imgPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var synopsisView: UIView!
    @IBOutlet weak var lbSynopsis: UILabel!
    var isSynopsisExpanded:Bool = true
    var baseSynosisY:CGFloat = 0;
    
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
         self.view.bringSubviewToFront(self.synopsisView)//avoid image overlaps
        self.view.sendSubviewToBack(self.imgPoster)
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        synopsisView.addGestureRecognizer(tap)
        
        lbTitle.text = movie["title"] as? String
        lbSynopsis.text = movie["synopsis"] as? String
        var strThumbnail = (movie.valueForKeyPath("posters.thumbnail") as! String)
       // imgPoster.setImageWithURL(Util.getHDThumbNail(strThumbnail)!)
        self.title = lbTitle.text
        self.baseSynosisY = self.synopsisView.frame.origin.y
        
        let photoUrlRequest : NSURLRequest = NSURLRequest(URL: Util.getHDThumbNail(strThumbnail)!)
        
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            self.imgPoster.image = image;
            self.imgPoster.alpha = 0
            UIView.animateWithDuration(2, animations: {
                self.imgPoster.alpha = 1.0
            })
        }
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        self.imgPoster.setImageWithURLRequest(photoUrlRequest, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)

        
        
    }
    func handleTap(sender: UITapGestureRecognizer) {
        // handling code
        self.triggerSynopsis()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.triggerSynopsis()
        
        
        
    }
    
    @IBAction func triggerSynopsisExpand(sender: UIView) {
        self.triggerSynopsis()
        
    }
    
    func triggerSynopsis() {
        var height = synopsisView.frame.size.height
        var width = synopsisView.frame.size.width
        var xPosition = synopsisView.frame.origin.x
        var yPosition:CGFloat = 0
        if(self.isSynopsisExpanded == false) {
            yPosition = self.baseSynosisY//self.synopsisView.frame.origin.y - height //+ (self.lbTitle.frame.size.height + 20)
            self.isSynopsisExpanded = true
        }
        else {
            yPosition = self.synopsisView.frame.origin.y + height - (self.lbTitle.frame.size.height + 20)
            self.isSynopsisExpanded = false
        }
        
        UIView.animateWithDuration(1.0, animations: {
            self.synopsisView.frame = CGRectMake(xPosition, yPosition, height, width)
        })
        
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
