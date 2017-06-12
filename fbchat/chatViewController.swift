//
//  chatViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/27/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import Firebase

class chatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var chatTable: UITableView!
//    @IBOutlet weak var chatWithLabel: UILabel!
    @IBOutlet weak var chatWithLabel: UITextView!
    @IBOutlet weak var sendMessageTextBox: UITextField!
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!
    
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    var allMessages: [[String:String]]! = []
    
    var userData: friendNode!
    var userFriends = [friendNode]()
    var messageID = ""
    var myName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userDAta NAME: \(userData.name)")
        configureChatLabel()
        generateMessageID()
        configureDatabase()
        addUsers()
        updateMessages()
    }
    
    //sets the chat label for a group chat
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
    
    //generates a unique message ID based on the IDs of all users in chat
    func generateMessageID(){
        var friendIDs = userFriends.map({(friend)->String in
            return friend.id})
        friendIDs.append(userData!.id)
        var sortedIDs = friendIDs.sorted()
        self.messageID = sortedIDs.reduce("", +)
        print(self.messageID)
    }


    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    //adds all users to database
    func addUsers(){
        addUser(ID: userData.id, name: userData.name)
        for friend in userFriends{
            addUser(ID: friend.id, name: friend.name)
        }
    }
    
    //helper method, adds one user to database if not already there
    func addUser(ID: String, name: String) {

        ref.child("users").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                //print("user exists already")
            }else{
                let newUserData = ["name": name as NSString,
                                   "contacts": [String: String]() as! NSDictionary,
                                   "messages": [String: String]() as! NSDictionary]
                self.ref.child("users").child(ID).setValue(newUserData)
            }
        })
    }
    
    // Listen for new messages in the Firebase database, and update the chat accordingly
    func updateMessages(){
        print(messageID)
        _refHandle = self.ref.child("users").child(userData.id).child("messages").child(messageID).observe(.childAdded, with: {[weak self] (snapshot) -> Void in guard let strongSelf = self else { return }
            if(snapshot.exists()){
                let messageNodeDict = snapshot.value as! [String: String]
                self?.allMessages.append(messageNodeDict)
                self?.chatTable.reloadData()
            }
        })
    }
    
    //packages message typed in textfield, and sends to database
    func send(data: String){
        if data != ""{
            let key = self.ref.child("users").child(userData.id).child("messages").childByAutoId().key
            var message = data
            let newMessageData = ["userName": userData.name,
                                  "userMessage": message,
                                "userID": userData.id]
            self.ref.child("users").child(userData.id).child("messages").child(messageID).child(key).setValue(newMessageData)
            for friend in userFriends{
            self.ref.child("users").child(friend.id).child("messages").child(messageID).child(key).setValue(newMessageData)
            }
            sendMessageTextBox.text = ""
        }
    }
    
    //sends message in textfield
    @IBAction func sendMessage(_ sender: Any) {
        if sendMessageTextBox.text != ""{
            send(data: sendMessageTextBox.text!)
        }
    }
    
    //manages text sent using the return button
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
        return allMessages.count
    }
    
    //manages chat table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cCell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! chatCell
        
        var nameAndMessages = getUserMessages()
        var userNames = nameAndMessages["userNames"] as! [String]
        var userMessages = nameAndMessages["userMessages"] as! [String]
        var userIDs = nameAndMessages["userIDs"] as! [String]

        var userProfiles = getUserProfiles(userIDs: userIDs) as! [UIImage]
        
        cCell.messageName.text = userNames[indexPath.row]
        cCell.messageText.text = userMessages[indexPath.row]
        cCell.userPic.image = userProfiles[indexPath.row]
        cCell.backgroundColor = UIColor.clear
        
        return cCell
    }
    
    //helper method, unpacks messages into an array of userNames and an array of userMessages
    func getUserMessages()->[String: [String]]{
        
        var userNames = [String]()
        var userMessages = [String]()
        var userIDs = [String]()
        
        let messageList = self.allMessages as [[String:String]]
        
        for message in self.allMessages{
            userNames.append(message["userName"]!)
            userMessages.append(message["userMessage"]!)
            userIDs.append(message["userID"]!)
        }
        
        var nameAndMessages = ["userNames": userNames as [String],
                               "userMessages": userMessages as [String],
                               "userIDs": userIDs as [String]
        ]
        return nameAndMessages
    }
    
    //helper method unpacks messages into an array of profile pictures to display in the chat using userIDs
    func getUserProfiles(userIDs: [String]) -> [UIImage]{
        var userProfiles = [UIImage]()
        for userID in userIDs{
            if userID == userData!.id{
                userProfiles.append(userData!.image)
            }else{
                for friend in userFriends{
                    if userID == friend.id {
                        userProfiles.append(friend.image)
                    }
                }
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
    
}
