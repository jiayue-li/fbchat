//
//  groupSearchCell.swift
//  fbchat
//
//  Created by Jiayue Li on 6/1/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//
import Foundation
import UIKit

class groupSearchCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    var friendInfo: friendNode!
    weak var delegate: groupChatSearchViewController?
    var selectedFriend = false
    
    @IBAction func selectFriend(_ sender: Any) {
        if selectedFriend == false {
            select()
        }else{
            unselect()
        }
        
    }
    
    func select(){
        self.delegate?.tempFriendsinChat.append(friendInfo)
        delegate?.resetGroupLabel()
        selectButton.setTitle("Unselect", for: .normal)
        selectedFriend = true
    }
    
    func unselect(){
        var tempFriends = self.delegate?.tempFriendsinChat as! [friendNode]
        if let index = tempFriends.index(of: friendInfo) {
            tempFriends.remove(at: index)
            print("removed \(friendInfo)")
            print("TempFriends now: \(tempFriends)")
            print("hi")
        }
        delegate?.resetGroupLabel()
        selectButton.setTitle("Select", for: .normal)
        selectedFriend = false
    }
    
}
