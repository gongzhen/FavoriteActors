//
//  FavoriteActorViewController.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class FavoriteActorViewController: UITableViewController, ActorPickerViewControllerDelegate {

    var actors = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addActor")
    }
    
    func addActor() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ActorPickerViewController") as! ActorPickerViewController
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // actorPicker is implemented because FavoriteActorViewController derived from ActorPickerViewControllerDelegate.
    func actorPicker(actorPicker: ActorPickerViewController, didPickActor actor: Person?) {        
        if let newActor = actor {
            for a in actors {
                if a.id == newActor.id {
                    return
                }
            }
            
            self.actors.append(newActor)
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let actor = actors[indexPath.row]
        let CellIdentifier = "ActorCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! ActorTableViewCell
        
        cell.nameLabel.text = actor.name
        cell.frameImageView.image = UIImage(named: "personFrame")
        
        if let localImage = actor.image {
            cell.actorImageView.image = localImage
        } else if actor.imagePath == nil || actor.imagePath == "" {
            // Handle the actor without imagepath.
            cell.actorImageView.image = UIImage(named: "personNoImage")
        }
        else {
            
            // Set the placeholder
            cell.actorImageView.image = UIImage(named: "personPlaceholder")
            
            // "w185"
            let size = TheMovieDB.sharedInstance().config.profileSizes[1]
            // print("imagePath: \(actor.imagePath!)")
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: actor.imagePath!,
                completionHandler: { (imageData, error) -> Void in
                if let data = imageData {
                    
                    // dispatch_async with main queue, otherwise the cell imageView wouldnot update.
                    dispatch_async(dispatch_get_main_queue()){ () -> Void in
                        let image = UIImage(data: data)
                        actor.image = image
                        cell.actorImageView.image = image
                    }
                }
            })
            cell.taskToCancelifCellIsReused = task
        }
        // Configure the cell...
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieListViewController") as! MovieListViewController
        controller.actor = self.actors[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch (editingStyle) {
        case .Delete:
            self.actors.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        default:
            break
        }
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
