//
//  signInViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/24/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin


class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
//        performSegue(withIdentifier: "SignInToFriendsList", sender:nil)
        print("should i even have printed")
        // Do any additional setup after loading the view, typically from a nib.
        FBSDKSettings.setAppID("1300012073416757")
                let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends])
        loginButton.center = view.center
        view.addSubview(loginButton)

        if (FBSDKAccessToken.current() != nil)
        {
            print("user logged in!!")
            self.performSegue(withIdentifier: "segue2", sender:nil)
        }else{
            print("user not logged in!\n")
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
