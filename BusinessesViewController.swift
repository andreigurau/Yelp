//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    var businesses: [Business]!
    var allBusinesses: [Business]!
    var filteredBusinesses: [Business]!
    var isMoreDataLoading = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        //searchBar = UISearchBar()
        //searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
        
            self.tableView.reloadData()
            self.allBusinesses = businesses
            for business in businesses {
                print(business.name!)
                print(business.address!)
                
            }
        })

/* //Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
    
    if businesses != nil
    {
        return businesses!.count
    }
    else
    {
    return 0
    }
    }
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        businesses = allBusinesses
        if searchText.isEmpty {
            businesses = allBusinesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredBusinesses = businesses!.filter({(dataItem: Business) -> Bool in
                
                let businessName = dataItem.name
                
                if businessName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    print("true")
                    return true
                } else {
                    print("false")
                    return false
                }
            })
        }
        businesses = filteredBusinesses
        tableView.reloadData()
        print("searchbar updated")
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        print("searchbar canceled")
        businesses = allBusinesses
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    
    /*func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            businesses = allBusinesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredBusinesses = businesses.filter({(dataItem: Business) -> Bool in
                
                let businessName = dataItem.name
                
                if businessName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }*/
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //print("scrolling")
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            //print("more data loading")
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                print("would load more data")
                // ... Code to load more results ...
                loadMoreData()
            }
        }
    }
    func loadMoreData()
    {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let test = sender as? UITableViewCell
        {
        let cell = sender as! UITableViewCell
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        let business = businesses![indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.business = business
        
        cell.selectionStyle = .None
        //let backgroundView = UIView()
        //backgroundView.backgroundColor = UIColor.redColor()
        //cell.selectedBackgroundView = backgroundView
        
        tableView.deselectRowAtIndexPath(indexPath!, animated:true)
        print("prepare for segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
    
    
}
