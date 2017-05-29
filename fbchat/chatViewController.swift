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
        var userID = userData?.id as! String
       
//        var userID = "person2"
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                print("true rooms exist")
            }else{
                print("this is not right....")
            }
        })
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
