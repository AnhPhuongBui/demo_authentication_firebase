//
//  InfoUserCell.swift
//  demo_authen
//
//  Created by Bui Anh Phuong on 10/11/21.
//

import UIKit

class InfoUserCell: UITableViewCell {
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet private weak var lbAge: UILabel!
    @IBOutlet private weak var lbAddress: UILabel!
    @IBOutlet private weak var lbNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUser(user: User) {
        lbName.text =  "Name: \(user.name)"
        lbAge.text = user.age
        lbAddress.text = user.address
        lbNumber.text = user.phoneNumber
    }
    
}
