//
//  groupChatSearchViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 6/1/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit

class groupChatSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    //instance variables

    @IBOutlet weak var searchTable: UITableView!
    var friendArray = [String]()
    var filteredFriendArray = [String]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return filteredFriendArray.count
        }else{
            return friendArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var friendCell = tableView.dequeueReusableCell(withIdentifier: "groupFriendCell", for: indexPath) as! groupSearchCell
        
        if shouldShowSearchResults {
            friendCell.userName.text = filteredFriendArray[indexPath.row]
        }else {
            friendCell.userName.text = friendArray[indexPath.row]
        }
        
        return friendCell
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

