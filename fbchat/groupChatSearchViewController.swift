//
//  groupChatSearchViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 6/1/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class groupChatSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate{
    
    //instance variables

    @IBOutlet weak var searchTable: UITableView!
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    var friends = [friendNode]()
    var filteredFriends = [friendNode]()
    var myInfo: friendNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureSearchController()
        print(friends)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return self.filteredFriends.count
        }else{
            return self.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var friendCell = tableView.dequeueReusableCell(withIdentifier: "groupFriendCell", for: indexPath) as! groupSearchCell
    
        var friendNames = [String]()
        var friendPics = [UIImage]()
        if shouldShowSearchResults {
            friendNames = filteredFriends.map({(friend)->String in
                return friend.name})
            friendPics = filteredFriends.map({(friend)->UIImage in
                return friend.image})
//            friendCell.userName.text = friendNames[indexPath.row]
//            friendCell.userPic.image = friendPics[indexPath.row]
        }else {
            friendNames = friends.map({(friend)->String in
                return friend.name})
            friendPics = friends.map({(friend)->UIImage in
                return friend.image})
//            friendCell.userName.text = friendNames[indexPath.row]
        }
        friendCell.userName.text = friendNames[indexPath.row]
        friendCell.userPic.image = friendPics[indexPath.row]
        
        return friendCell
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search friends..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchTable.tableHeaderView = searchController.searchBar

    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text
        
        self.filteredFriends = friends.filter({ (friend) -> Bool in
            let friendName: NSString = friend.name as NSString
            return (friendName.range(of: searchText!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
        
        searchTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        print("editing....")
        searchTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults{
            shouldShowSearchResults = true
            searchTable.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        shouldShowSearchResults = false
        searchTable.reloadData()
    }
}

