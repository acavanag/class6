//
//  MovieTableViewController.swift
//  MovieApp
//
//  Created by Andrew Cavanagh on 10/14/15.
//  Copyright © 2015 andrewjmc. All rights reserved.
//

import UIKit

private let kReuseIdentifier = "movieCell"
private let kPosterSegue = "posterSegue"

class MovieTableViewController: UITableViewController {

    var dataSource = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchPressed(sender: AnyObject) {
        
        //step 1: a string!
        let urlString = "http://www.omdbapi.com/?s=harry+potter"
        
        //step 2: a url!
        let url = NSURL(string: urlString)!
        
        //step 3: a url request
        let urlRequest = NSURLRequest(URL: url)
        
        //step 4: generate task
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { [weak self] (data, response, error) -> Void in
            // this block is executed on our BACKGROUND thread
            
            if let _self = self {
                // FIXME: -- Handle your errors!
                
                if let data = data where error == nil {
                    
                    // transform binary data into JSON
                    let json = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
                    
                    // transform JSON into an array of Movie objects (which our datasource expects)
                    let parsedMovies = Movie.parseMovieJSON(json)
                    
                    // Move OFF of the background thread and onto the MAIN thread to perform updates and drawing on our tableview.
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Set our datasource
                        _self.dataSource = parsedMovies
                        // Reload our table!
                        _self.tableView.reloadData()
                    })
                    
                }
            }
        }
        
        //step 5: Resume
        task.resume()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReuseIdentifier, forIndexPath: indexPath)

        let movie = dataSource[indexPath.row]
        cell.textLabel?.text = movie.name

        return cell
    }
    
    // MARK: - Table view delegate
    
    // This function is called when a user taps a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kPosterSegue, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kPosterSegue {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                if let posterController = segue.destinationViewController as? PosterViewController {
                    
                    let movie = dataSource[selectedIndex.row]
                    posterController.movie = movie
                    
                }
            }
        }
    }
    
}
