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
    @IBOutlet weak var groupChatLabel: UITextView!

    var searchController: UISearchController!

    var shouldShowSearchResults = false
    var friends = [friendNode]()
    var filteredFriends = [friendNode]()
    var myInfo: friendNode!
    var tempFriendsinChat = [friendNode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addDummyUser()
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
    
        friendCell.delegate = self
        
        var friendNames = [String]()
        var friendPics = [UIImage]()
        if shouldShowSearchResults {
            friendNames = filteredFriends.map({(friend)->String in
                return friend.name})
            friendPics = filteredFriends.map({(friend)->UIImage in
                return friend.image})
            friendCell.friendInfo = filteredFriends[indexPath.row]
        }else {
            friendNames = friends.map({(friend)->String in
                return friend.name})
            friendPics = friends.map({(friend)->UIImage in
                return friend.image})
            friendCell.friendInfo = friends[indexPath.row]
        }
        friendCell.userName.text = friendNames[indexPath.row]
        friendCell.userPic.image = friendPics[indexPath.row]
        
        return friendCell
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.dimsBackgroundDuringPresentation = false
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
    
    func resetGroupLabel(){
        if tempFriendsinChat.count == 0 {
            print(tempFriendsinChat)
            groupChatLabel.text = ""
        }else{
            print(tempFriendsinChat)
            var groupChatLabelText = "Group Chat with "
            for friend in tempFriendsinChat { 
                groupChatLabelText = groupChatLabelText + friend.name + ", "
            }
            var num = groupChatLabelText.characters.count-2
            var index = groupChatLabelText.index(groupChatLabelText.startIndex, offsetBy: num)
            groupChatLabelText = groupChatLabelText.substring(to: index)
            groupChatLabel.text = groupChatLabelText
        }
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

    func addDummyUser(){
        var p1 = friendNode(name: "person1", image: myInfo.image, id: "12345")
        friends.append(p1)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGroupChat"{
            if let chatVC = segue.destination as? chatViewController {
                chatVC.userData = myInfo!
                chatVC.userFriends = self.tempFriendsinChat
            }

        }
        
    }
    @IBAction func startGroupChat(_ sender: Any) {
        performSegue(withIdentifier: "segueToGroupChat", sender: nil)
    }
    
}

