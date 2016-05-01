//
//  Config.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit


// MARK: - Files Support
private let _documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
private let _fileURL: NSURL = _documentsDirectoryURL.URLByAppendingPathComponent("TheMovieDB-Context")

class Config: NSObject, NSCoding {

    // Default values from 1/12/15  
    var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
    var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
    var profileSizes = ["w45", "w185", "h632", "original"]
    
    override init() {
        
    }
    
    convenience init?(dictionary: [String: AnyObject]) {
        self.init()
        
    }
    
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
    class func unarchivedInstance() -> Config? {
        // _fileUrl
        // file:///Users/gongzhen/Library/Developer/CoreSimulator/Devices/FC701544-43B0-4CF3-8070-30AA63516006/data/Containers/Data/Application/CE1CDE71-86C4-4E4A-BD7B-45E001209C98/Documents/TheMovieDB-Context
        if NSFileManager.defaultManager().fileExistsAtPath(_fileURL.path!) {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(_fileURL.path!) as? Config
        } else {
            return nil
        }
    }
    
}
