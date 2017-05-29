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
    var messages: [Database]! = []
    fileprivate var _refHandle: DatabaseHandle!
    
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    
    var userData: friendNode?
    var userFriendData: friendNode?
    
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
        var friendName = self.userFriendData?.name as! String
        
        configureDatabase()
        addUser()
        chatWithLabel?.text = friendName

        
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
    }
    
    func addUser() {
//        var userID = userData?.id as! String
//        var userName = userData?.name as! String
       
        var userID = "person3"
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
            
            sendMessageTextBox.text = ""
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: return num messages
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var chatCell = tableView.dequeueReusableCell(withIdentifier: "chatCell")
        
        return chatCell!
    }
    
    
    
}
