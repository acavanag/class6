//
//  PosterViewController.swift
//  MovieApp
//
//  Created by Andrew Cavanagh on 10/14/15.
//  Copyright © 2015 andrewjmc. All rights reserved.
//

import UIKit

final class PosterViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhoto()
        
        title = movie?.name
    }
    
    func fetchPhoto() {
        if let movie = movie {
            let urlString = movie.imageUrlString
            let url = NSURL(string: urlString)!
            let urlRequest = NSURLRequest(URL: url)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { [weak self] (data, response, error) -> Void in
                if let _self = self {
                    // FIXME: -- Handle your errors!
                    // make sure our data exists and we have no error (not a substitute for good error handling!)
                    if let data = data where error == nil {
                        
                        // transform our binary into a UIImage object
                        let image = UIImage(data: data)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            _self.posterImageView.image = image
                        })
                    }
                }
            })
            task.resume()
        }
    }
    
}
