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
    
    var friendInfo: friendNode!
    weak var delegate: groupChatSearchViewController?
    
    @IBAction func selectFriend(_ sender: Any) {
        self.delegate?.tempFriendsinChat.append(friendInfo)
        delegate?.resetGroupLabel()
    }
    
}
