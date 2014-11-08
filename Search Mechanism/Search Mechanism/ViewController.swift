//
//  ViewController.swift
//  Search Mechanism
//
//  Created by E. Mozharovsky on 11/6/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    // Initialize and sort in alphabetical order.
    let cities = ["Boston", "New York", "Oregon", "Tampa", "Los Angeles", "Dallas", "Miami", "Olympia", "Montgomery", "Washington", "Orlando", "Detroit"].sorted {
        $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending
    }
    
    var searchController: UISearchController?
    var searchResultsController: UITableViewController?
    
    let identifier = "Cell"
    
    // Filtered results are stored here.
    var results: NSMutableArray?
    
    // MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A table for search results and its controller.
        let resultsTableView = UITableView(frame: self.tableView.frame)
        self.searchResultsController = UITableViewController()
        self.searchResultsController?.tableView = resultsTableView
        self.searchResultsController?.tableView.dataSource = self
        self.searchResultsController?.tableView.delegate = self
        
        // Register cell class for the identifier.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        self.searchResultsController?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController!)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController?.searchBar
        
        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hideSearchBar()
    }
    
    // MARK:- Util methods
    
    func hideSearchBar() {
        let yOffset = self.navigationController!.navigationBar.bounds.height + UIApplication.sharedApplication().statusBarFrame.height
        self.tableView.contentOffset = CGPointMake(0, self.searchController!.searchBar.bounds.height - yOffset)
    }

    // MARK:- UITableView methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchResultsController?.tableView {
            if let results = self.results {
                return results.count
            } else {
                return 0
            }
        } else {
            return self.cities.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier) as UITableViewCell
        
        var text: String?
        if tableView == self.searchResultsController?.tableView {
            if let results = self.results {
                text = self.results!.objectAtIndex(indexPath.row) as? String
            }
        } else {
            text = self.cities[indexPath.row]
        }
        
        cell.textLabel.text = text
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == self.searchResultsController?.tableView {
            // Remove search bar & hide it.
            self.searchController?.active = false
            self.hideSearchBar()
        }
    }
    
    // MARK:- UISearchResultsUpdating methods 
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if self.searchController?.searchBar.text.lengthOfBytesUsingEncoding(NSUTF32StringEncoding) > 0 {
            if let results = self.results {
                results.removeAllObjects()
            } else {
                results = NSMutableArray(capacity: self.cities.count)
            }
            
            let searchBarText = self.searchController!.searchBar.text
           
            let predicate = NSPredicate(block: { (city: AnyObject!, b: [NSObject : AnyObject]!) -> Bool in
                var range: NSRange = 0
                if city is NSString {
                    range = city.rangeOfString(searchBarText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                }
                
                return range.location != NSNotFound
            })
            
            // Get results from predicate and add them to the appropriate array.
            let filteredArray = (self.cities as NSArray).filteredArrayUsingPredicate(predicate)
            self.results?.addObjectsFromArray(filteredArray)
            
            // Reload a table with results.
            self.searchResultsController?.tableView.reloadData()
        }
    }
    
    // MARK:- UISearchControllerDelegate methods 
    
    func didDismissSearchController(searchController: UISearchController) {
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.hideSearchBar()
        }, completion: nil)
    }
}

