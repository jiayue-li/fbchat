//
//  userData.swift
//  fbchat
//
//  Created by Jiayue Li on 5/27/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import Foundation
import UIKit

struct userChatData{
    var userName: String
    var userID: String
    var userPhotoURL: String
    var friendName: String
    var friendID: String
    var friendPhotoURL: String
}

struct friendNode:Equatable {
    var name:String
    var image:UIImage
    var id:String
    
    static func == (lhs: friendNode, rhs: friendNode) -> Bool {
        return lhs.id == rhs.id
    }
}
