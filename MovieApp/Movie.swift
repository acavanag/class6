//
//  Movie.swift
//  MovieApp
//
//  Created by Andrew Cavanagh on 10/14/15.
//  Copyright © 2015 andrewjmc. All rights reserved.
//

import Foundation

struct Movie {
    let name: String
    let imageUrlString: String
    
    static func parseMovieJSON(json: AnyObject) -> [Movie] {
        
        var movieArray = [Movie]()
        
        if let movieDictionary = json as? [String : AnyObject] {
            if let searchArray = movieDictionary["Search"] as? [[String : AnyObject]] {
                for movieResult in searchArray {
                    if let movieTitle = movieResult["Title"] as? String,
                           poster = movieResult["Poster"] as? String {
                        let movie = Movie(name: movieTitle, imageUrlString: poster)
                            movieArray.append(movie)
                    }
                }
            }
        }
        
        return movieArray
        
    }
    
}