//
//  friendCell.swift
//  fbchat
//
//  Created by Jiayue Li on 5/27/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import Foundation
import UIKit


class myTableCell: UITableViewCell{
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
    //    var userName: String?
    //    var userID: String?
    //    var userImageURL: String?
    //    var friendName: String?
    //    var friendID: String?
    //    var friendPhotoURL: String?
    
    var userNode: friendNode?
    var userFriendNode: friendNode?
    weak var delegate: ChangeViewProtocol?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected:Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func startChat(_ sender: Any) {
        presentDestinationViewController()
    }
    
    func presentDestinationViewController() {
        let chatVC = chatViewController(nibName: "chatViewController", bundle: nil)
        chatVC.userData = self.userNode
        chatVC.userFriendData = self.userFriendNode
        print(chatVC.userData)
        delegate?.loadNewScreen(controller: chatVC)
    }
    
}

protocol ChangeViewProtocol : NSObjectProtocol {
    func loadNewScreen(controller: UIViewController) -> Void;
}
