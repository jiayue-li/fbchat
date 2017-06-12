//
//  groupSearchCell.swift
//  fbchat
//
//  Created by Jiayue Li on 6/1/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//
import Foundation
import UIKit

class groupSearchCellInfo {
    var node: friendNode
    var selected: Bool
    
    init(node: friendNode, selected: Bool) {
        self.node = node
        self.selected = selected
    }
}
class groupSearchCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    var cellInfo: groupSearchCellInfo!
    var friendInfo: friendNode!
    weak var delegate: groupChatSearchViewController?

    
    @IBAction func selectFriend(_ sender: Any) {
        if selectedFriend() == false {
            select()
        }else{
            unselect()
        }
        
    }
    
    //checks if friend is added to chat yet
    func selectedFriend() -> Bool{
//        var tempFriends = self.delegate?.tempFriendsinChat as! [friendNode]
//        for friend in tempFriends{
//            if friend.id == id{
//                return true
//            }
//        }
//        return false
        return cellInfo.selected
    }
    
    func select(){
        self.delegate?.tempFriendsinChat.append(cellInfo.node)
        delegate?.resetGroupLabel()
        cellInfo.selected = true
        configureSelectButton()
    }
    
    func unselect(){
        var tempFriends = self.delegate?.tempFriendsinChat as! [friendNode]
        if let index = self.delegate?.tempFriendsinChat.index(of: cellInfo.node) {
            self.delegate?.tempFriendsinChat.remove(at: index)
        }
        delegate?.resetGroupLabel()
        cellInfo.selected = false
        configureSelectButton()
    }
    
    func configureSelectButton(){
        if cellInfo.selected{
            selectButton.setTitle("Unselect", for: .normal)
        }else{
            selectButton.setTitle("Select", for: .normal)
        }
    }
    
}
