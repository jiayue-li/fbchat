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
        configureDatabase()
        addUser()
        configureMessages()
        chatWithLabel?.text = friendName

        
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").child("person1").child("messages").observe(.childAdded, with: {[weak self] (snapshot) -> Void in guard let strongSelf = self else { return }
            if(snapshot.exists()){
            print(snapshot)
            print(snapshot.value!)
            let messageNodeDict = snapshot.value as! [String:[String:String]]
            
            
            var componentArray = Array(messageNodeDict.keys)
            print(componentArray)
            let messageKey = componentArray[0]
            print(messageKey)
            self?.allMessages.append(messageNodeDict[messageKey]!)
            self?.chatTable.reloadData()
        }
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
    
    func configureMessages(){
        ref.child("users").child("person1").child("messages").child("person2").observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()){
                let idkMirror2 = Mirror(reflecting: snapshot.value!)
                print("snapshot.value type: \(idkMirror2.subjectType)")
                let messagesList = snapshot.children
            for messageSnap in messagesList {
//                let idkMirror1 = Mirror(reflecting: messageSnap)
//                print("message type: \(idkMirror1.subjectType)")
                print("message: \(messageSnap)")
                let messageSnapshot = messageSnap as! DataSnapshot
                var message = messageSnapshot.value!
                self.allMessages.append(message as! [String : String])
//                var componentArray = Array(message.keys)
//                key = componentArray[0]
//                self.allMessages.append(message[key])
//                print(message)
                }
            }
        })
        self.chatTable.reloadData()
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
            
            let key = self.ref.child("users").child(userID).child("messages").childByAutoId().key
            print(key)
            
            var message = sendMessageTextBox.text
            let newMessageData = ["userName": userName,
                                  "userMessage": message]
            
            
            self.ref.child("users").child(userID).child("messages").child(friendID).child(key).setValue(newMessageData)
            self.ref.child("users").child(friendID).child("messages").child(userID).child(key).setValue(newMessageData)
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
