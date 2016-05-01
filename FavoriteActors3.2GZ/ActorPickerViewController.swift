//
//  ActorPickerViewController.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

protocol ActorPickerViewControllerDelegate {
    func actorPicker(actorPicker: ActorPickerViewController, didPickActor actor: Person?)
}

class ActorPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // The data for the table
    var actors = [Person]()
    
    // The delegate will typically be a view controller, waiting for the Actor Picker
    // to return an actor
    var delegate: ActorPickerViewControllerDelegate?
    
    // The most recent data download task. We keep a reference to it so that it can
    // be canceled every time the search text changes
    var searchTask: NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
        // Create the right button as cancel button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        
//        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate // <FavoriteActors3_2GZ.AppDelegate: 0x7fea52d0c160>
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        self.delegate?.actorPicker(self, didPickActor: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Search Bar Delegate
    
    // Each time the search text changes we want to cancel any current download and start a new one
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: \(searchText)")
        // Cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        if searchText == "" {
            actors = [Person]()
            tableView.reloadData()
            objc_sync_exit(self)
            return
        }
        
        // Start a new one download
        let resource = TheMovieDB.Resources.SearchPerson // search/person
        let parameters = ["query" : searchText]

        searchTask = TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters, completionHandler: { (result, error) -> Void in
            
            // Handle the error case
            if let error = error {
                print("Error searching for actors: \(error.localizedDescription)")
                return
            }
            
            // Get a Swift dictionary from the JSON data
            if let actorDictionaries = result.valueForKey("results") as? [[String: AnyObject]] {
                self.searchTask = nil

                self.actors = actorDictionaries.map({ (personDict: [String : AnyObject]) -> Person in
                    Person(dictionary: personDict)
                })
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActorSearchCell", forIndexPath: indexPath)
        cell.textLabel?.text = actors[indexPath.row].name
        
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actor = actors[indexPath.row]
        
        // Alert the delegate
        delegate?.actorPicker(self, didPickActor: actor)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
