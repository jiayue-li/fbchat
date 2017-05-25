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


class FriendsListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.current() != nil)
        {
            print("friendslistviewloaded")
//            let params = ["fields": "id, first_name, last_name, name, picture"]
//
//            var gRequest = FBSDKGraphRequest(graphPath:"me", parameters: params);
//            let connection = FBSDKGraphRequestConnection();
//            print(connection)
//            connection.add(gRequest, completionHandler:{ (connection, result, error) in
//                if error == nil {
//                    print("no error")
//                    if let userData = result as? [String:Any] {
//                        print("connection made")
//                        print(userData)
//                    }
//                } else {
//                    print("Error Getting Friends");
//                }
//            })
//            
//            connection.start()
            fetchProfile()
        }else{
            print("Please log in to continue")
        }
        
        

    }
    
    func fetchProfile(){
        let params = ["fields": "id, first_name, last_name, name, picture"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start(completionHandler: {(connection, result, error) -> Void in
            if error != nil{
                print(error)
                return
            }
            guard let resultNew = result as? [String:Any] else {
                return
            }
//            print (resultNew["data"])
            let fName = resultNew["data"]  as! NSArray
            print(fName[0])
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
