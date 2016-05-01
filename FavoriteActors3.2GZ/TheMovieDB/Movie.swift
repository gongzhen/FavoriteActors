//
//  Movie.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class Movie {

    struct Keys {
        static let Title = "title"
        static let PosterPath = "poster_path"
        static let ReleaseDate = "release_date"
        static let ID = "id"
    }
    
    var title: String
    var id: NSNumber
    var posterPath: String?
    var releaseDate: NSDate?
    var actor: Person?

    init(dictionary: [String : AnyObject]) {
        
        // Dictionary
        title = dictionary[Keys.Title] as! String
        id = dictionary[Keys.ID] as! NSNumber
        posterPath = dictionary[Keys.PosterPath] as? String
        
        if let releaseDateString = dictionary[Keys.ReleaseDate] as? String {
            releaseDate = TheMovieDB.sharedDateFormatter.dateFromString(releaseDateString)
        }        
    }
    
    var posterImage: UIImage? {
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
        }
        
        set{
            TheMovieDB.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
        }
    }
}
