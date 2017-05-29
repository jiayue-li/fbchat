//
//  chatViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/27/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import Firebase


//struct userChatData{
//    var userName: String
//    var userID: String
//    var userPhotoURL: String
//    var friendName: String
//    var friendID: String
//    var friendPhotoURL: String
//}

class chatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatWithLabel: UILabel!
    
    
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
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        print(userData)
        var friendName = self.userFriendData?.name as! String
        print(friendName)
        chatWithLabel?.text = friendName
        // Do any additional setup after loading the view, typically from a nib.
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
