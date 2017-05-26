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


class myTableCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
    @IBAction func startChat(_ sender: Any) {
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected:Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }

}
class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var friendsTable: UITableView!
    
    @IBOutlet weak var username: UILabel!
    //    var friends = ["frienddd"]
    struct friendNode {
        var name:String
        var image:UIImage
    }
    var friends = [friendNode]()
//    var friends = [String]()
//    var imageURLs = [String]()
    
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
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start(completionHandler: {(connection, result, error) -> Void in
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
                //unpacking each friend's userNode and adding to arrays
                print(user["name"]!)
                var userName = user["name"] as? String
//                self.friends.append(userName!)
                
                var userPicture = user["picture"] as? [String: Any]
                var userPicData = userPicture?["data"] as? [String: Any]
                let userPicURL = userPicData?["url"] as? String
                let url = URL(string: userPicURL!)
                let data = try? Data(contentsOf: url!)
                let userImage = UIImage(data: data!) as! UIImage
                
                let friendStruct = friendNode(name: userName!, image: userImage)
                
                self.friends.append(friendStruct)
//                self.imageURLs.append(userPicURL!)
                
//                let userPic = Mirror(reflecting: userImageURL)
//                print("Type: \(userPic.subjectType)")
//                self.imageURLs.append(userImageURL as! String)
//                print(self.friends)
//                print("imageURLSize: \(self.imageURLs.count)")
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
//        let friendCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
//        friendCell.textLabel?.text = friends[indexPath.row]
//        return(friendCell)
//        let friendCell = self.friendsTable.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
//        DispatchQueue.main.async{
//            cell.imageView?.image = UIImage.init(data: )
//        }
        
        var friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! myTableCell
        
        var friendNames = [String]()
        var friendPics = [UIImage]()
        
        let friendsList = self.friends as [friendNode]
        
        for fNode in self.friends {
            friendNames.append(fNode.name as String)
            friendPics.append(fNode.image as UIImage)
        }
        
//        friendCell.textLabel?.text = friendNames[indexPath.row]
        
//        var imageName = UIImage(named: transportItems[indexPath.row])
//        friendCell.imageView?.image = friendPics[indexPath.row]
        
        friendCell.username.text = friendNames[indexPath.row]
        friendCell.userPic.image = friendPics[indexPath.row]

        return friendCell
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        friendsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


