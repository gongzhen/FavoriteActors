//
//  TaskCancelingTableViewCell.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class TaskCancelingTableViewCell: UITableViewCell {

    var imageName: String = ""
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}
