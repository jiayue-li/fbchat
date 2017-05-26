//
//  FriendsListViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/24/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit



class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var friendsTable: UITableView!
    
//    var friends = ["frienddd"]
    var friends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.current() != nil)
        {
            print("friendslistviewloaded")
            fetchProfile()
            friendsTable.reloadData()
        }else{
            print("Please log in to continue")
        }
        
        
    }
    
    
    
    @IBAction func backToSI(_ sender: Any) {
        print("hi")
        self.performSegue(withIdentifier: "segueBack", sender: nil)
    }
    
    
    func fetchProfile(){
        print("fetching profile.....")
        let params = ["fields": "id, first_name, last_name, name, picture"]
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start(completionHandler: {(connection, result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            guard let resultNew = result as? [String:Any] else {
                return
            }
            
            let data = resultNew["data"]  as! NSArray
            for userNode in data {
                guard let user = userNode as? [String:Any] else {
                    return
                }
                
//                let idkMirror = Mirror(reflecting: user)
//                print(idkMirror.subjectType)
                print(user["name"]!)
                var userName = user["name"]!
                self.friends.append(userName as! String)
                print(self.friends[0])
//                var someArray = [String]()
//                someArray.append(userName as! String)
//                self.friendsTable.beginUpdates()
//                self.friendsTable.insertRows(at: [IndexPath(row: someArray.count-1, section: 0)], with: .automatic)
//                self.friendsTable.endUpdates()
            }
            self.friendsTable.reloadData()
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("friends:  \(friends.count)")
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        friendCell.textLabel?.text = friends[indexPath.row]
        return(friendCell)
//        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        friendsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
