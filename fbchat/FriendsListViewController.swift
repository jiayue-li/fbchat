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


class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeViewProtocol {
    
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var username: UILabel!
    
    var friends = [friendNode]()
    var myInfo: friendNode?
    var tempFriendInfo: friendNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.current() != nil)
        {
//            print("friendslistviewloaded")
            fetchProfile()
            fetchFriendsProfiles()
            self.friendsTable.reloadData()
            
        }else{
            print("Please log in to continue")
        }
    }
    
    @IBAction func backToSI(_ sender: Any) {
        self.performSegue(withIdentifier: "segueBack", sender: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start(completionHandler: {(connection, result, error) -> Void in
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
                    return
                }
                
                //                let idkMirror = Mirror(reflecting: user)
                //                print(idkMirror.subjectType)
                //unpacking each friend's userNode and adding to arrays
//                print(user["name"]!)
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
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! myTableCell
        
        friendCell.delegate = self
        
        var userNames = [String]()
        var userID = [String]()
        var userPicURLs = [String]()
        
        
        var friendNames = [String]()
        var friendPics = [UIImage]()
        
        let friendsList = self.friends as [friendNode]
        
        for fNode in self.friends {
            friendNames.append(fNode.name as String)
            friendPics.append(fNode.image as UIImage)
        }
        
        friendCell.userNode = myInfo
        friendCell.userFriendNode = friends[indexPath.row]
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
                chatVC.userFriendData = self.tempFriendInfo!
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


