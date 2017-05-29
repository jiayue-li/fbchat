//
//  chatViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/27/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import Firebase

class chatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatWithLabel: UILabel!
    @IBOutlet weak var sendMessageTextBox: UITextField!
    var ref: DatabaseReference!
    var allMessages: [[String:String]]! = []
    var messages: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle!
    
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    
    var userData: friendNode?
    var userFriendData: friendNode?
    var userID: String!
    var friendID: String!
    
//    init(userData: friendNode, userFriendData:friendNode){
//        self.userData = userData
//        self.userFriendData = userFriendData
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTable.reloadData()
        var friendName = self.userFriendData?.name as! String
        self.userID = self.userData?.id as! String
        self.friendID = self.userFriendData?.id as! String
        print(allMessages)
        var dict = ["userName": "p1",
                    "userMessage": "blahblah"]
        allMessages.append(dict)
        print(allMessages)
        configureDatabase()
        addUser()
        chatWithLabel?.text = friendName

        
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").child("person1").child("messages").observe(.childAdded, with: {[weak self] (snapshot) -> Void in guard let strongSelf = self else { return }
//            strongSelf.messages.append(snapshot)
//            strongSelf.chatTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            print(snapshot)
            self?.chatTable.reloadData()
        })
    }
    
    func addUser() {
//        var userID = userData?.id as! String
//        var userName = userData?.name as! String
       
        var userID = "person1"
        var userName = "p1"
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                print("user exists already")
            }else{
                let newUserData = ["name": userName as NSString,
                                   "contacts": [String: String]() as! NSDictionary,
                                   "messages": [String: String]() as! NSDictionary]
                self.ref.child("users").child(userID).setValue(newUserData)
//                print("user does not exist")
            }
        })
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if sendMessageTextBox.text != ""{
//            var userID = userData?.id as! String
//            var userName = userData?.name as! String
//            var friendID = userFriendData?.id as! String
//            var friendName = userFriendData?.id as! String
            var userID = "person1"
            var userName = "p1"
            var friendID = "person2"
            var friendName = "p2"
            
            var message = sendMessageTextBox.text
            let newMessageData = ["userName": userName,
                                  "userMessage": message]
            
            self.ref.child("users").child(userID).child("messages").child(friendID).setValue(newMessageData)
            self.ref.child("users").child(friendID).child("messages").child(userID).setValue(newMessageData)
            sendMessageTextBox.text = ""
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: return num messages
        print(allMessages.count)
        return allMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("changing table...")
        print(tableView)
        var cCell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! chatCell
//        
//        chatCell.delegate = self
        var userNames = [String]()
        var userMessages = [String]()
        
        let messageList = self.allMessages as [[String:String]]
        
        for message in self.allMessages{
            userNames.append(message["userName"]!)
            userMessages.append(message["userMessage"]!)
        }
//        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        cCell.messageName.text = userNames[indexPath.row]
        cCell.messageText.text = userMessages[indexPath.row]
        return cCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        chatTable.delegate = self
//        chatTable.dataSource = self
        chatTable.reloadData()
    }


    
    
}
