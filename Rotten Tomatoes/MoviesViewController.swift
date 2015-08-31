//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Do Ngoc Tan on 8/26/15.
//  Copyright (c) 2015 Do Ngoc Tan. All rights reserved.
//

import UIKit
import Foundation

class MoviesViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate,UITabBarDelegate, UISearchBarDelegate {
    
    
    // @IBOutlet weak var loadingProgress: UIActivityIndicatorView!
    
    
    @IBOutlet weak var tbvMovies: UITableView!
    @IBOutlet weak var tabmvType: UITabBar!
    @IBOutlet weak var tabTopMovies: UITabBarItem!
    @IBOutlet weak var tabTopDVDs: UITabBarItem!
    
    var movies: [NSDictionary]?
    var filters: [NSDictionary]=[]
    var refreshControl = UIRefreshControl()
    var errorView = UIView()
    var cachedDataUrlString: String = ""
    var searchActive : Bool = false
    var mvFilter: String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.loadingProgress.startAnimating()
        
        // Do any additional setup after loading the view.
        //        let tabBarHeight = self.tabmvType.bounds.height
        //  self.edgesForExtendedLayout = UIRectEdge.All
        // self.tbvMovies.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);//UIEdgeInsets(top: 0.0, left: 0.0, bottom: tabBarHeight, right: 0.0)
        // self.tbvMovies.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0)
        
        self.initErrorView()
        self.refreshControl.addTarget(self, action: Selector("loadDataFromServer"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        self.tbvMovies?.addSubview(refreshControl)
        //self.loadDataFromServer()
        tbvMovies.dataSource = self
        tbvMovies.delegate = self
        searchBar.delegate = self
        self.tabmvType.delegate = self
        self.tabmvType.selectedItem = self.tabTopMovies
        tabBar(self.tabmvType, didSelectItem: self.tabTopMovies)
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(tabmvType.selectedItem?.title == "Top Movies" ) {
            cachedDataUrlString =  "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json" as String
        }
        else if(tabmvType.selectedItem?.title == "Top DVD") {
            cachedDataUrlString = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json" as String
        }
        
        self.loadDataFromServer()
    }
    
    func loadDataFromServer() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.center = view.center
        indicator.color = UIColor.greenColor()
        view.addSubview(indicator)
        indicator.startAnimating()
        
        
        
        let url = NSURL( string: cachedDataUrlString )!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
            
            if error != nil
            {
                //                var alert = UIAlertController(title: "Error", message: "Could not load Data :( \(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                //                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                //                self.presentViewController(alert, animated: true, completion: nil)
                
                if self.refreshControl.refreshing
                {
                    self.refreshControl.endRefreshing()
                }
                self.displayNetworkStatus(true)
                
            }
            else {
                self.displayNetworkStatus(false)
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as? NSDictionary
                
                if let dictionary = dictionary {
                    if(self.movies?.isEmpty == nil) {
                        self.movies?.removeAll(keepCapacity: false)
                    }
                    
                    self.movies = dictionary["movies"] as? [NSDictionary]
                    
                    //                    if(self.mvFilter != "") {
                    //
                    //                        self.movies =  self.movies?.filter({  if let movie = $0["title"] as? String {
                    //                            return movie == self.mvFilter
                    //                        } else {
                    //                            return false
                    //                            }  })
                    //
                    //                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if self.refreshControl.refreshing
                        {
                            self.refreshControl.endRefreshing()
                        }
                        
                        
                        self.tbvMovies.reloadData()
                        
                        
                    })
                    
                    //  self.loadingProgress.stopAnimating()
                }
                
            }
        })
        
    }
    
    func displayNetworkStatus(isError: Bool) {
        //errorView.hidden = isError
        if(isError) {
            
            
            UIView.animateWithDuration(1.0, animations: {
                self.errorView.frame.origin.y = self.navigationController!.navigationBar.frame.size.height
            })
            // self.tbvMovies.frame.origin.y = self.tbvMovies.frame.origin.y + self.errorView.frame.height
        }
        else {
            UIView.animateWithDuration(1.0, animations: {
                self.errorView.frame.origin.y = 0
                
            })
            // self.tbvMovies.frame.origin.y = self.tbvMovies.frame.origin.y - self.errorView.frame.height
            
        }
        
        
    }
    
    func initErrorView() {
        let parentW = self.view.frame.width
        
        
        self.errorView = UIView(frame: CGRectMake(0, 0, parentW, 50))
        errorView.backgroundColor = Util.UIColorFromHex(0xa88803, alpha: 0.5)
        
        var alert = UILabel(frame: CGRectMake(errorView.frame.width/2, 50, 300, 21))
        alert.center = errorView.center
        alert.frame.origin.y+=10
        alert.text = "Network Error. Please Try Again!!!!!"
        alert.textColor = Util.UIColorFromHex(0xef077b)
        errorView.addSubview(alert)
        errorView.bringSubviewToFront(alert)
        self.view.addSubview(errorView)
        self.view.bringSubviewToFront(errorView)
        //errorView.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return self.filters.count
        }
        if let movies = self.movies {
            return movies.count
        }
        else {
            return 0
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tbvMovies.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        cell.backgroundColor =  Util.UIColorFromHex(0x141413, alpha:0.95)
        var movie:NSDictionary!
        if(self.searchActive) {
            movie = self.filters[indexPath.row]
        }
        else {
            movie = movies![indexPath.row]
        }
       // let movie = movies![indexPath.row]
        cell.lbTitle.text = movie["title"] as? String
        cell.lbSynopsis.text = movie["synopsis"] as? String
        
        var strThumbnail = (movie.valueForKeyPath("posters.thumbnail") as! String)
        //cell.imgPoster.setImageWithURL(Util.getHDThumbNail(strThumbnail)!)
        
        
        let photoUrlRequest : NSURLRequest = NSURLRequest(URL: Util.getHDThumbNail(strThumbnail)!)
        
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            cell.imgPoster.image = image;
            cell.imgPoster.alpha = 0
            UIView.animateWithDuration(0.2, animations: {
                cell.imgPoster.alpha = 1.0
            })
        }
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        cell.imgPoster.setImageWithURLRequest(photoUrlRequest, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
        
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tbvMovies.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        self.tbvMovies.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.mvFilter = ""
        // self.loadDataFromServer()
        self.tbvMovies.reloadData()
        self.searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        
        self.mvFilter = self.searchBar.text!
        self.tbvMovies.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filters = self.movies!.filter({ if let title = $0["title"] as? String  {
            let tmp: NSString = NSString(string:title)
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        }
        else {
            return false
            }
        })
        if(self.filters.count == 0){
           // searchActive = false;
        } else {
            searchActive = true;
        }
        self.tbvMovies.reloadData()
        
    }
    
    
    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tbvMovies.indexPathForCell(cell)!
        let movie = movies![indexPath.row]
        let vc = segue.destinationViewController as! MovieDetailViewController
        vc.movie = movie
    }
    
    
}
