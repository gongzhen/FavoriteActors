//
//  Person.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class Person {
    
    struct Keys {
        static let Name = "name"
        static let ProfilePath = "profile_path"
        static let Movies = "movies"
        static let ID = "id"
    }

    var name: String
    var id: NSNumber
    var imagePath: String?
    var movies: [Movie]?
    
    init(dictionary: [String: AnyObject]) {
        name = dictionary[Keys.Name] as! String
        id = dictionary[Keys.ID] as! Int
        
        if let pathForImage = dictionary[Keys.ProfilePath] as? String {
            imagePath = pathForImage
        }
    }
    
    var image: UIImage?
}
