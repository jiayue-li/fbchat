//
//  signInViewController.swift
//  fbchat
//
//  Created by Jiayue Li on 5/24/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookLogin


class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Called when the button was used to login and the process finished.
     
     - parameter loginButton: Button that was used to login.
     - parameter result:      The result of the login.
     */
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            print("user logged in")
            print(FBSDKAccessToken.current())
            return
        }
        print("user logged in")
        
        print(FBSDKAccessToken.current())
        // ...
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("User Logged Out")
    }
    
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        print("User Logged In")
//        print(FBSDKAccessToken.current())
//        performSegue(withIdentifier: "segue2", sender: nil)
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: LoginButton){
//        print("User Logged out")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
//        if (!SignInViewController.isAlreadyLaunchedOnce){
//            print("configuring...")
//            FirebaseApp.configure()
//            print("configured")
//            SignInViewController.isAlreadyLaunchedOnce = true
//        }
        FBSDKSettings.setAppID("1300012073416757")
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        let loginButton = FBSDKLoginButton(readPermissions:[ .publicProfile, .email, .userFriends])
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            print("user logged in!!")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                // ...
                if let error = error {
                    // ...
                    return
                }
            }

        }else{
            print("user not logged in!\n")
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
