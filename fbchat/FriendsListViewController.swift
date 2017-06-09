//
//  FriendsListViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/24/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit


class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeViewProtocol, UISearchResultsUpdating, UISearchBarDelegate{
    
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var username: UILabel!
    
    var friends = [friendNode]()
    var filteredFriends = [friendNode]()
    var myInfo: friendNode?
    var tempFriendInfo: friendNode?
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.current() != nil)
        {
//            print("friendslistviewloaded")
            fetchProfile()
            fetchFriendsProfiles()
            configureSearchController()
            self.friendsTable.reloadData()
            
        }else{
            print("Please log in to continue")
        }
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search friends..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        friendsTable.tableHeaderView = searchController.searchBar
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        self.filteredFriends = friends.filter({ (friend) -> Bool in
            let friendName: NSString = friend.name as NSString
            return (friendName.range(of: searchText!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        friendsTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        friendsTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults{
            shouldShowSearchResults = true
            friendsTable.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        shouldShowSearchResults = false
        friendsTable.reloadData()
    }

    
    @IBAction func backToSI(_ sender: Any) {
        self.performSegue(withIdentifier: "segueBack", sender: nil)
    }
    
    
    func fetchProfile(){
        //        print("fetching profile.....")
        let params = ["fields": "id, first_name, last_name, name, picture"]
        FBSDKGraphRequest(graphPath: "me", parameters: params).start(completionHandler: {(connection, result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            guard let resultMe = result as? [String:Any] else {
                return
            }
            
            print(resultMe)
            var myName = resultMe["name"] as? String
            var myID = resultMe["id"] as? String
            
            var userPicture = resultMe["picture"] as? [String: Any]
            var userPicData = userPicture?["data"] as? [String: Any]
            let userPicURL = userPicData?["url"] as? String
            let url = URL(string: userPicURL!)
            let data = try? Data(contentsOf: url!)
            let userImage = UIImage(data: data!) as! UIImage
            var myPicURL = resultMe["picture"] as? String
            
            self.myInfo = friendNode(name: myName!, image: userImage, id: myID!)
        })
        
    }
    
    func fetchFriendsProfiles(){
        let params = ["fields": "id, first_name, last_name, name, picture"]
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start(completionHandler: {(connection, result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            guard let resultFriends = result as? [String:Any] else {
                return
            }
            
            let data = resultFriends["data"]  as! NSArray
            for userNode in data {
                guard let user = userNode as? [String:Any] else {
                    return}
                var userName = user["name"] as? String
                //                self.friends.append(userName!)
                
                var userPicture = user["picture"] as? [String: Any]
                var userPicData = userPicture?["data"] as? [String: Any]
                let userPicURL = userPicData?["url"] as? String
                let url = URL(string: userPicURL!)
                let data = try? Data(contentsOf: url!)
                let userImage = UIImage(data: data!) as! UIImage
                
                var userID = user["id"] as? String
                
                let friendStruct = friendNode(name: userName!, image: userImage, id: userID!)
                
                self.friends.append(friendStruct)
            }
            self.friendsTable.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return self.filteredFriends.count
        }else{
            return self.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! myTableCell
        
        friendCell.delegate = self
        
//        var userNames = [String]()
//        var userID = [String]()
//        var userPicURLs = [String]()
//        
//        
//        var friendNames = [String]()
//        var friendPics = [UIImage]()
//        
//        let friendsList = self.friends as [friendNode]
//        
//        for fNode in self.friends {
//            friendNames.append(fNode.name as String)
//            friendPics.append(fNode.image as UIImage)
//        }
//        
//        friendCell.userNode = myInfo
//        friendCell.userFriendNode = friends[indexPath.row]
//        friendCell.username.text = friendNames[indexPath.row]
//        friendCell.userPic.image = friendPics[indexPath.row]
        var friendNames = [String]()
        var friendPics = [UIImage]()
        if shouldShowSearchResults {
            friendNames = filteredFriends.map({(friend)->String in
                return friend.name})
            friendPics = filteredFriends.map({(friend)->UIImage in
                return friend.image})
            friendCell.userNode = filteredFriends[indexPath.row]
        }else {
            friendNames = friends.map({(friend)->String in
                return friend.name})
            friendPics = friends.map({(friend)->UIImage in
                return friend.image})
            friendCell.userNode = friends[indexPath.row]
        }
        friendCell.username.text = friendNames[indexPath.row]
        friendCell.userPic.image = friendPics[indexPath.row]
        friendCell.backgroundColor = UIColor.clear
        
        return friendCell
    }
    
    func loadNewScreen(controller: UIViewController) {
        self.present(controller, animated: true) { () -> Void in
        };
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguetoChat" {
            if let chatVC = segue.destination as? chatViewController {
                chatVC.userData = myInfo!
                chatVC.userFriends.append(self.tempFriendInfo!)
            }
        }
        
        if segue.identifier == "segueToGroupChatSearch" {
            if let groupSearch = segue.destination as? groupChatSearchViewController {
                groupSearch.friends = self.friends
                groupSearch.myInfo = self.myInfo!
            }
        }
    }
    
    func openChat(userData: friendNode, userFriendData: friendNode){
//        print(userFriendData)
        self.tempFriendInfo = userFriendData;
        performSegue(withIdentifier: "seguetoChat", sender: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        friendsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


