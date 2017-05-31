//
//  chatCell.swift
//  fbchat
//
//  Created by Jiayue Li on 5/27/17.
//  Copyright © 2017 Jiayue Li. All rights reserved.
//

import Foundation
import UIKit

class chatCell: UITableViewCell {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var messageName: UILabel!
    @IBOutlet weak var messageText: UITextView!
    
    override func setSelected(_ selected:Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
    
}
