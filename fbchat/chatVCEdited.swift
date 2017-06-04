//
//  chatVCEdited.swift
//  fbchat
//
//  Created by Jiayue Li on 6/2/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class chatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatWithLabel: UILabel!
    @IBOutlet weak var sendMessageTextBox: UITextField!
    var ref: DatabaseReference!
    var allMessages: [[String:String]]! = []
    fileprivate var _refHandle: DatabaseHandle!
    
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    
    var userData: friendNode?
    var userFriends = [friendNode]()
    var userFriendData: friendNode?
    var messageID = ""
    var userID: String!
    var myName: String!
    var friendID: String!
    var friendName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChatLabel()
        generateMessageID()
        setUserIDs()
        configureDatabase()
        addUsers()
        updateMessages()
    }
    
    func configureChatLabel() {
        var chatWithLabelText = ""
        for friend in userFriends {
            chatWithLabelText = chatWithLabelText + friend.name + ", "
        }
        var num = chatWithLabelText.characters.count-2
        var index = chatWithLabelText.index(chatWithLabelText.startIndex, offsetBy: num)
        chatWithLabelText = chatWithLabelText.substring(to: index)
        chatWithLabel.text = chatWithLabelText
    }
    
    func generateMessageID(){
        var friendIDs = userFriends.map({(friend)->String in
            return friend.id})
        var sortedIDs = friendIDs.sorted()
        self.messageID = sortedIDs.reduce("", +)
    }
    
    
    func setUserIDs(){
        self.friendName = self.userFriendData?.name as! String
        self.friendID = self.userFriendData?.id as! String
        self.userID = self.userData?.id as! String
        self.myName = self.userData?.name as! String

    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func updateMessages(){
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").child(self.userID).child("messages").child(messageID).observe(.childAdded, with: {[weak self] (snapshot) -> Void in guard let strongSelf = self else { return }
            if(snapshot.exists()){
                //            print(snapshot)
                //            print("new message : \(snapshot.value!)")
                let messageNodeDict = snapshot.value as! [String: String]
                self?.allMessages.append(messageNodeDict)
                self?.chatTable.reloadData()
            }
        })
        
    }
    
    func addUsers(){
        addUser(ID: userID, name: myName)
        for friend in userFriends{
            addUser(ID: friend.id, name: friend.name)
        }
    }
    
    func addUser(ID: String, name: String) {
        //        var userID = "person1"
        //        var userName = "p1"
        ref.child("users").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                //                print("user exists already")
            }else{
                let newUserData = ["name": name as NSString,
                                   "contacts": [String: String]() as! NSDictionary,
                                   "messages": [String: String]() as! NSDictionary]
                self.ref.child("users").child(ID).setValue(newUserData)
            }
        })
    }
    
    func send(data: String){
        if data != ""{
            var userID = userData?.id as! String
            var userName = userData?.name as! String
            var friendID = userFriendData?.id as! String
            var friendName = userFriendData?.id as! String
            //            var userID = "person1"
            //            var userName = "p1"
            //            var friendID = "person2"
            //            var friendName = "p2"
            
            let key = self.ref.child("users").child(userID).child("messages").childByAutoId().key
            
            var message = data
            let newMessageData = ["userName": userName,
                                  "userMessage": message]
            
            
            self.ref.child("users").child(userID).child("messages").child(friendID).child(key).setValue(newMessageData)
            self.ref.child("users").child(friendID).child("messages").child(userID).child(key).setValue(newMessageData)
            sendMessageTextBox.text = ""
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if sendMessageTextBox.text != ""{
            send(data: sendMessageTextBox.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        view.endEditing(true)
        send(data: text)
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: return num messages
        return allMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cCell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! chatCell
        
        var nameAndMessages = getUserMessages()
        var userNames = nameAndMessages["userNames"] as! [String]
        var userMessages = nameAndMessages["userMessages"] as! [String]
        var userProfiles = getUserProfiles(userNames: userNames) as! [UIImage]
        
        cCell.messageName.text = userNames[indexPath.row]
        cCell.messageText.text = userMessages[indexPath.row]
        cCell.userPic.image = userProfiles[indexPath.row]
        cCell.backgroundColor = UIColor.clear
        
        return cCell
    }
    
    func getUserMessages()->[String: [String]]{
        
        var userNames = [String]()
        var userMessages = [String]()
        
        let messageList = self.allMessages as [[String:String]]
        
        for message in self.allMessages{
            userNames.append(message["userName"]!)
            userMessages.append(message["userMessage"]!)
        }
        
        var nameAndMessages = ["userNames": userNames as [String],
                               "userMessages": userMessages as [String]
        ]
        return nameAndMessages
    }
    
    func getUserProfiles(userNames: [String]) -> [UIImage]{
        print("hi")
        var userProfiles = [UIImage]()
        for userName in userNames{
            if userName == self.userData?.name{
                userProfiles.append((self.userData?.image)!)
            }else{
                userProfiles.append((self.userFriendData?.image)!)
            }
        }
        return userProfiles
    }
    
    func resetUser(userID: String, userName: String) {
        let newUserData = ["name": userName as NSString,
                           "contacts": [String: String]() as! NSDictionary,
                           "messages": [String: String]() as! NSDictionary]
        self.ref.child("users").child(userID).setValue(newUserData)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //        chatTable.delegate = self
        //        chatTable.dataSource = self
        chatTable.reloadData()
    }
    
    
}
