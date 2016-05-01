//
//  MovieListViewController.swift
//  FavoriteActors3.2GZ
//
//  Created by gongzhen on 4/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class MovieListViewController: UITableViewController {

    var actor: Person!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if actor.movies == nil || actor.movies?.isEmpty == true {
            let resource = TheMovieDB.Resources.PersonIDMovieCredits
            let parameters = [TheMovieDB.Keys.ID: actor.id]
            TheMovieDB.sharedInstance().taskForResource(resource, parameters: parameters, completionHandler: { (result, error) -> Void in
                if let error = error {
                    print(error)
                } else {
                    if let moviesDictionaries = result.valueForKey("cast") as? [[String: AnyObject]] {
                        // print(moviesDictionaries[0])
                        let movieArrays = moviesDictionaries.map({ (movieDict :[String : AnyObject]) -> Movie in
                            let movie = Movie(dictionary: movieDict)
                            movie.actor = self.actor
                            return movie
                        })
                        // print(movieArrays)
                        // Update the table on the main thread
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //Assign actor's movies to self.actor.movies.
                            self.actor.movies = movieArrays
                            self.tableView.reloadData()
                        })
                    } else {
                        let error = NSError(domain: "Movie for Person Parsing. Can't find cast in \(result).", code: 0, userInfo: nil)
                        print("\(error)")
                    }
                }
            })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actor.movies?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! TaskCancelingTableViewCell
        let movie = actor.movies![indexPath.row]
        var posterImage = UIImage(named: "posterPlaceHolder")
        
        cell.textLabel?.text = movie.title
        cell.imageView?.image = nil
        // print("movie posterPath :\(movie.posterPath!)")
        if movie.posterPath == nil || movie.posterPath == "" {
            posterImage = UIImage(named: "noImage")
        }
        
//        else if movie.posterPath != nil {
//            // Just for generate the poster image without core data.
//            posterImage = movie.posterImage
//        }
        
        else {
            // This is the interesting case. The movie has an image name, but it is not downloaded yet.
            // This first line returns a string representing the second to the smallest size that TheMovieDB serves up
            let size = TheMovieDB.sharedInstance().config.posterSizes[1]
            
            let task = TheMovieDB.sharedInstance().taskForImageWithSize(size, filePath: movie.posterPath!, completionHandler: { (data, error) -> Void in
                
                if let error = error {
                    print("Poster download error: \(error.localizedDescription)")
                }
                
                if let data = data {
                    // Create the image
                    let image = UIImage(data: data)
                    
                    // update the model, so that the infrmation gets cashed
                    movie.posterImage = image
                    
                    // update the cell later, on the main thread
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.imageView?.image = image
                    })
                }
            })
            
            // why we do it here.
            cell.taskToCancelifCellIsReused = task
        }
        cell.imageView?.image = posterImage
        return cell
    }
}
